class RdapEntity {
    [string]           $Handle
    [string]           $ObjectClassName
    [System.Object]    $VcardArray
    [System.Object[]]  $Roles
    [System.Object[]]  $Entities
    [System.Object[]]  $Events
    [System.Object[]]  $Links
    [System.Object[]]  $Status
    [System.Object[]]  $Remarks
    [System.Object]    $RawResponse

    RdapEntity([psobject] $response) {
        $this.Handle = $response.handle
        $this.ObjectClassName = $response.objectClassName
        $this.VcardArray = $response.vcardArray
        $this.Roles = $response.roles
        $this.Entities = $response.entities
        $this.Events = $response.events
        $this.Links = $response.links
        $this.Status = $response.status
        $this.Remarks = $response.remarks
        $this.RawResponse = $response
    }
}

class RdapNameserver {
    [string]           $Handle
    [string]           $ObjectClassName
    [string]           $LdhName
    [string]           $UnicodeName
    [System.Object]    $IpAddresses
    [System.Object[]]  $Entities
    [System.Object[]]  $Events
    [System.Object[]]  $Links
    [System.Object[]]  $Status
    [System.Object[]]  $Remarks
    [System.Object]    $RawResponse

    RdapNameserver([psobject] $response) {
        $this.Handle = $response.handle
        $this.ObjectClassName = $response.objectClassName
        $this.LdhName = $response.ldhName
        $this.UnicodeName = $response.unicodeName
        $this.IpAddresses = $response.ipAddresses
        $this.Entities = $response.entities
        $this.Events = $response.events
        $this.Links = $response.links
        $this.Status = $response.status
        $this.Remarks = $response.remarks
        $this.RawResponse = $response
    }
}

class RdapIpNetwork {
    [string]           $Handle
    [string]           $ObjectClassName
    [string]           $StartAddress
    [string]           $EndAddress
    [string]           $IpVersion
    [string]           $Name
    [string]           $Type
    [string]           $Country
    [string]           $ParentHandle
    [System.Object[]]  $Entities
    [System.Object[]]  $Events
    [System.Object[]]  $Links
    [System.Object[]]  $Status
    [System.Object[]]  $Remarks
    [System.Object]    $RawResponse

    RdapIpNetwork([psobject] $response) {
        $this.Handle = $response.handle
        $this.ObjectClassName = $response.objectClassName
        $this.StartAddress = $response.startAddress
        $this.EndAddress = $response.endAddress
        $this.IpVersion = $response.ipVersion
        $this.Name = $response.name
        $this.Type = $response.type
        $this.Country = $response.country
        $this.ParentHandle = $response.parentHandle
        $this.Entities = $response.entities
        $this.Events = $response.events
        $this.Links = $response.links
        $this.Status = $response.status
        $this.Remarks = $response.remarks
        $this.RawResponse = $response
    }
}

class RdapAutnum {
    [string]           $Handle
    [string]           $ObjectClassName
    [long]             $StartAutnum
    [long]             $EndAutnum
    [string]           $Name
    [string]           $Type
    [string]           $Country
    [System.Object[]]  $Entities
    [System.Object[]]  $Events
    [System.Object[]]  $Links
    [System.Object[]]  $Status
    [System.Object[]]  $Remarks
    [System.Object]    $RawResponse

    RdapAutnum([psobject] $response) {
        $this.Handle = $response.handle
        $this.ObjectClassName = $response.objectClassName
        if ($null -ne $response.startAutnum) { $this.StartAutnum = [long]$response.startAutnum }
        if ($null -ne $response.endAutnum) { $this.EndAutnum = [long]$response.endAutnum }
        $this.Name = $response.name
        $this.Type = $response.type
        $this.Country = $response.country
        $this.Entities = $response.entities
        $this.Events = $response.events
        $this.Links = $response.links
        $this.Status = $response.status
        $this.Remarks = $response.remarks
        $this.RawResponse = $response
    }
}

class RdapDomain {
    [string]           $Handle
    [string]           $ObjectClassName
    [string]           $LdhName
    [string]           $UnicodeName
    [System.Object[]]  $Nameservers
    [System.Object]    $SecureDns
    [System.Object[]]  $Entities
    [System.Object[]]  $Events
    [System.Object[]]  $Links
    [System.Object[]]  $Status
    [System.Object[]]  $Remarks
    [System.Object]    $RawResponse

    RdapDomain([psobject] $response) {
        $this.Handle = $response.handle
        $this.ObjectClassName = $response.objectClassName
        $this.LdhName = $response.ldhName
        $this.UnicodeName = $response.unicodeName
        $this.Nameservers = $response.nameservers
        $this.SecureDns = $response.secureDNS
        $this.Entities = $response.entities
        $this.Events = $response.events
        $this.Links = $response.links
        $this.Status = $response.status
        $this.Remarks = $response.remarks
        $this.RawResponse = $response
    }
}

class RdapHelp {
    [System.Object[]]  $RdapConformance
    [System.Object[]]  $Notices
    [System.Object]    $RawResponse

    RdapHelp([psobject] $response) {
        $this.RdapConformance = $response.rdapConformance
        $this.Notices = $response.notices
        $this.RawResponse = $response
    }
}
