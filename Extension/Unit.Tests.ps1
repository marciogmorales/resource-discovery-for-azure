# Import the Pester module if not already imported
# Import-Module Pester

Describe 'Script Validation Tests' {

    # Test cases for missing parameters
    Context 'Missing Parameter Validation' {

        It 'Throws error when Task parameter is missing' {
            { 
                . "$PSScriptRoot\Metrics.ps1" -Subscriptions @() -Resources @() -File 'output.json' -Metrics $null -TableStyle 'TableStyleMedium2' -ConcurrencyLimit 2 -FilePath 'output' 
            } | Should -Throw
        }

        It 'Throws error when File parameter is missing' {
            { 
                . "$PSScriptRoot\Metrics.ps1" -Subscriptions @() -Resources @() -Task 'Processing' -Metrics $null -TableStyle 'TableStyleMedium2' -ConcurrencyLimit 2 -FilePath 'output' 
            } | Should -Throw
        }

        It 'Does not throw error when all required parameters are provided' {
            { 
                . "$PSScriptRoot\Metrics.ps1" -Subscriptions @() -Resources @() -Task 'Processing' -File 'output.json' -Metrics $null -TableStyle 'TableStyleMedium2' -ConcurrencyLimit 2 -FilePath 'output' 
            } | Should -Not -Throw
        }
    }

    # Test cases for invalid Task parameter values
    Context 'Task Parameter Validation' {

        It 'Throws error when Task is not "Processing"' {
            { 
                . "$PSScriptRoot\Metrics.ps1" -Subscriptions @() -Resources @() -Task 'InvalidTask' -File 'output.json' -Metrics $null -TableStyle 'TableStyleMedium2' -ConcurrencyLimit 2 -FilePath 'output' 
            } | Should -Throw
        }

        It 'Does not throw error when Task is "Processing"' {
            { 
                . "$PSScriptRoot\Metrics.ps1" -Subscriptions @() -Resources @() -Task 'Processing' -File 'output.json' -Metrics $null -TableStyle 'TableStyleMedium2' -ConcurrencyLimit 2 -FilePath 'output' 
            } | Should -Not -Throw
        }
    }

    # Test cases for other validation scenarios (if applicable)
    Context 'Other Parameter Validation' {

        It 'Throws error when ConcurrencyLimit is not provided' {
            { 
                . "$PSScriptRoot\Metrics.ps1" -Subscriptions @() -Resources @() -Task 'Processing' -File 'output.json' -Metrics $null -TableStyle 'TableStyleMedium2' -FilePath 'output' 
            } | Should -Throw
        }

        It 'Does not throw error when ConcurrencyLimit is provided' {
            { 
                . "$PSScriptRoot\Metrics.ps1" -Subscriptions @() -Resources @() -Task 'Processing' -File 'output.json' -Metrics $null -TableStyle 'TableStyleMedium2' -ConcurrencyLimit 2 -FilePath 'output' 
            } | Should -Not -Throw
        }
    }
}