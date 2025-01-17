@{
    AllNodes = @(
        @{
            NodeName        = "SPWFENACS"
            RunCentralAdmin = $true
            ServerRole      = "WebFrontEndWithDistributedCache"
        },
        @{
            NodeName        = "SPAPPNACS"
            RunCentralAdmin = $false
            ServerRole      = "Application"
        },
        @{
            NodeName        = "SPSEARCHNACS"
            RunCentralAdmin = $false
            ServerRole      = "Search"
        }
    )
    Environment = @{
        Domain         = "contoso.dev"
        DatabaseServer = "SPSQLNACS"
    }
}
