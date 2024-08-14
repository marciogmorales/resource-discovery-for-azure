# Import-Module to ensure script functions are available in the Pester tests
# Replace 'YourScript.ps1' with the actual script filename

Describe 'Metric Processing Script Tests' {

    # Sample input data
    $sampleSubscriptions = @(
        [PSCustomObject]@{ id = 'sub1'; Name = 'Subscription 1' },
        [PSCustomObject]@{ id = 'sub2'; Name = 'Subscription 2' }
    )

    $sampleResources = @(
        [PSCustomObject]@{ TYPE = 'microsoft.compute/virtualmachines'; subscriptionId = 'sub1'; Id = 'vm1'; ResourceGroup = 'RG1'; Name = 'VM1'; Location = 'eastus' },
        [PSCustomObject]@{ TYPE = 'microsoft.storage/storageaccounts'; subscriptionId = 'sub2'; Id = 'storage1'; ResourceGroup = 'RG2'; Name = 'Storage1'; Location = 'westus' },
        [PSCustomObject]@{ TYPE = 'microsoft.sql/servers/databases'; subscriptionId = 'sub1'; Id = 'sql1'; ResourceGroup = 'RG1'; Name = 'SQL1'; Location = 'eastus'; kind = 'vcore' },
        [PSCustomObject]@{ TYPE = 'microsoft.web/sites'; subscriptionId = 'sub2'; Id = 'app1'; ResourceGroup = 'RG2'; Name = 'App1'; Location = 'westus'; kind = 'functionapp' }
    )

    $sampleTask = 'Processing'
    $sampleFile = 'output.xlsx'
    $sampleMetrics = $null
    $sampleTableStyle = 'TableStyleMedium2'
    $sampleConcurrencyLimit = 2
    $sampleFilePath = 'output'

    # Mock Get-AzMetric function
    Mock -CommandName Get-AzMetric -MockWith {
        return [PSCustomObject]@{ Data = [PSCustomObject]@{ Average = @(0.2, 0.3, 0.1) } }
    }

    # Run the script before the tests
    BeforeAll {
        . "$PSScriptRoot\YourScript.ps1" -Subscriptions $sampleSubscriptions -Resources $sampleResources -Task $sampleTask -File $sampleFile -Metrics $sampleMetrics -TableStyle $sampleTableStyle -ConcurrencyLimit $sampleConcurrencyLimit -FilePath $sampleFilePath
    }

    # Test Metric Definitions for Virtual Machines
    It 'Processes Virtual Machine Metrics Correctly' {
        # Assert Metric Definitions
        $metricDefs = Get-Variable -Name 'metricDefs' -ValueOnly
        $metricDefs | Should -Not -BeNullOrEmpty
        $metricDefs.Count | Should -BeGreaterThan 0

        # Assert Specific Metric Properties for Virtual Machines
        $vmMetric = $metricDefs | Where-Object { $_.Service -eq 'Virtual Machines' }
        $vmMetric.MetricName | Should -Be 'Percentage CPU'
        $vmMetric.Service | Should -Be 'Virtual Machines'
    }

    # Test Metric Definitions for Storage Accounts
    It 'Processes Storage Account Metrics Correctly' {
        # Assert Metric Definitions
        $metricDefs = Get-Variable -Name 'metricDefs' -ValueOnly
        $metricDefs | Should -Not -BeNullOrEmpty
        $metricDefs.Count | Should -BeGreaterThan 0

        # Assert Specific Metric Properties for Storage Accounts
        $storageMetric = $metricDefs | Where-Object { $_.Service -eq 'Storage Account' }
        $storageMetric.MetricName | Should -Be 'UsedCapacity'
        $storageMetric.Service | Should -Be 'Storage Account'
    }

    # Test Metric Definitions for SQL Databases
    It 'Processes SQL Database Metrics Correctly' {
        # Assert Metric Definitions
        $metricDefs = Get-Variable -Name 'metricDefs' -ValueOnly
        $metricDefs | Should -Not -BeNullOrEmpty
        $metricDefs.Count | Should -BeGreaterThan 0

        # Assert Specific Metric Properties for SQL Databases
        $sqlMetric = $metricDefs | Where-Object { $_.Service -eq 'SQL Database' }
        $sqlMetric.MetricName | Should -Be 'cpu_limit'
        $sqlMetric.Service | Should -Be 'SQL Database'
    }

    # Test Metric Definitions for App Services
    It 'Processes App Service Metrics Correctly' {
        # Assert Metric Definitions
        $metricDefs = Get-Variable -Name 'metricDefs' -ValueOnly
        $metricDefs | Should -Not -BeNullOrEmpty
        $metricDefs.Count | Should -BeGreaterThan 0

        # Assert Specific Metric Properties for App Services
        $appServiceMetric = $metricDefs | Where-Object { $_.Service -eq 'Functions' }
        $appServiceMetric.MetricName | Should -Be 'FunctionExecutionCount'
        $appServiceMetric.Service | Should -Be 'Functions'
    }

    # Add more tests as necessary for other resources (MariaDB, PostgreSQL, etc.)

}