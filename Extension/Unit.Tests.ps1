# Comprehensive Unit Tests for Metrics.ps1

Describe 'Metrics.ps1 - Comprehensive Validation Tests' {

    # Mock data for testing
    $mockSubscriptions = @(
        [PSCustomObject]@{ id = 'sub1'; Name = 'Subscription 1' },
        [PSCustomObject]@{ id = 'sub2'; Name = 'Subscription 2' }
    )

    $mockResources = @(
        [PSCustomObject]@{ TYPE = 'microsoft.compute/virtualmachines'; subscriptionId = 'sub1'; Id = 'vm1'; ResourceGroup = 'RG1'; Name = 'VM1'; Location = 'eastus' },
        [PSCustomObject]@{ TYPE = 'microsoft.storage/storageaccounts'; subscriptionId = 'sub2'; Id = 'storage1'; ResourceGroup = 'RG2'; Name = 'Storage1'; Location = 'westus' }
    )

    $validTask = 'Processing'
    $invalidTask = 'InvalidTask'
    $validFile = 'output.json'
    $invalidFile = ''
    $validConcurrencyLimit = 2
    $invalidConcurrencyLimit = -1
    $filePath = 'output'
    $tableStyle = 'TableStyleMedium2'
    $metrics = $null

    # Missing Parameters Tests
    Context 'Missing Parameter Validation' {
        It 'Throws an error when Task parameter is missing' {
            {
                . "$PSScriptRoot\Metrics.ps1" -Subscriptions $mockSubscriptions -Resources $mockResources -File $validFile -Metrics $metrics -TableStyle $tableStyle -ConcurrencyLimit $validConcurrencyLimit -FilePath $filePath
            } | Should -Throw -ErrorMessage "A parameter cannot be found that matches parameter name 'Task'."
        }

        It 'Throws an error when File parameter is missing' {
            {
                . "$PSScriptRoot\Metrics.ps1" -Subscriptions $mockSubscriptions -Resources $mockResources -Task $validTask -Metrics $metrics -TableStyle $tableStyle -ConcurrencyLimit $validConcurrencyLimit -FilePath $filePath
            } | Should -Throw -ErrorMessage "A parameter cannot be found that matches parameter name 'File'."
        }
    }

    # Task Parameter Tests
    Context 'Task Parameter Validation' {
        It 'Throws an error when Task parameter has an invalid value' {
            {
                . "$PSScriptRoot\Metrics.ps1" -Subscriptions $mockSubscriptions -Resources $mockResources -Task $invalidTask -File $validFile -Metrics $metrics -TableStyle $tableStyle -ConcurrencyLimit $validConcurrencyLimit -FilePath $filePath
            } | Should -Throw -ErrorMessage "Task must be either 'Processing' or 'Reporting'"
        }

        It 'Does not throw an error when Task parameter is valid' {
            {
                . "$PSScriptRoot\Metrics.ps1" -Subscriptions $mockSubscriptions -Resources $mockResources -Task $validTask -File $validFile -Metrics $metrics -TableStyle $tableStyle -ConcurrencyLimit $validConcurrencyLimit -FilePath $filePath
            } | Should -Not -Throw
        }
    }

    # ConcurrencyLimit Tests
    Context 'ConcurrencyLimit Parameter Validation' {
        It 'Throws an error when ConcurrencyLimit is negative' {
            {
                . "$PSScriptRoot\Metrics.ps1" -Subscriptions $mockSubscriptions -Resources $mockResources -Task $validTask -File $validFile -Metrics $metrics -TableStyle $tableStyle -ConcurrencyLimit $invalidConcurrencyLimit -FilePath $filePath
            } | Should -Throw -ErrorMessage "ConcurrencyLimit must be a positive integer."
        }

        It 'Does not throw an error when ConcurrencyLimit is valid' {
            {
                . "$PSScriptRoot\Metrics.ps1" -Subscriptions $mockSubscriptions -Resources $mockResources -Task $validTask -File $validFile -Metrics $metrics -TableStyle $tableStyle -ConcurrencyLimit $validConcurrencyLimit -FilePath $filePath
            } | Should -Not -Throw
        }
    }

    # File Path Validation
    Context 'File Parameter Validation' {
        It 'Throws an error when File parameter is empty' {
            {
                . "$PSScriptRoot\Metrics.ps1" -Subscriptions $mockSubscriptions -Resources $mockResources -Task $validTask -File $invalidFile -Metrics $metrics -TableStyle $tableStyle -ConcurrencyLimit $validConcurrencyLimit -FilePath $filePath
            } | Should -Throw -ErrorMessage "Cannot bind argument to parameter 'File' because it is an empty string."
        }

        It 'Does not throw an error when File parameter is valid' {
            {
                . "$PSScriptRoot\Metrics.ps1" -Subscriptions $mockSubscriptions -Resources $mockResources -Task $validTask -File $validFile -Metrics $metrics -TableStyle $tableStyle -ConcurrencyLimit $validConcurrencyLimit -FilePath $filePath
            } | Should -Not -Throw
        }
    }

    # Test for proper handling of inputs and expected output
    Context 'Valid Scenario Tests' {

        BeforeEach {
            # Setup for valid scenarios, if any specific setup is needed
        }

        It 'Processes Virtual Machine Metrics correctly' {
            {
                . "$PSScriptRoot\Metrics.ps1" -Subscriptions $mockSubscriptions -Resources $mockResources -Task $validTask -File $validFile -Metrics $metrics -TableStyle $tableStyle -ConcurrencyLimit $validConcurrencyLimit -FilePath $filePath
            } | Should -Not -Throw

            # Assuming script produces a file, validate its existence
            Test-Path "$filePath\_1.json" | Should -Be $true
        }

        It 'Processes Storage Account Metrics correctly' {
            {
                . "$PSScriptRoot\Metrics.ps1" -Subscriptions $mockSubscriptions -Resources $mockResources -Task $validTask -File $validFile -Metrics $metrics -TableStyle $tableStyle -ConcurrencyLimit $validConcurrencyLimit -FilePath $filePath
            } | Should -Not -Throw

            # Assuming script produces a file, validate its existence
            Test-Path "$filePath\_1.json" | Should -Be $true
        }

        It 'Handles mixed resource types correctly' {
            $mixedResources = $mockResources + [PSCustomObject]@{ TYPE = 'microsoft.sql/servers/databases'; subscriptionId = 'sub1'; Id = 'sql1'; ResourceGroup = 'RG1'; Name = 'SQL1'; Location = 'eastus'; kind = 'vcore' }
            {
                . "$PSScriptRoot\Metrics.ps1" -Subscriptions $mockSubscriptions -Resources $mixedResources -Task $validTask -File $validFile -Metrics $metrics -TableStyle $tableStyle -ConcurrencyLimit $validConcurrencyLimit -FilePath $filePath
            } | Should -Not -Throw

            # Validate the correct processing of all resource types
            Test-Path "$filePath\_1.json" | Should -Be $true
        }
    }

    # Cleanup after tests, if needed
    AfterAll {
        # Remove any files or reset any settings if needed
        Remove-Item "$filePath\*.json" -ErrorAction SilentlyContinue
    }
}