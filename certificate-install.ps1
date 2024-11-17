<#
get-ChildItem -Path Cert:\ -Recurse | where {$_.issuer -match 'MPF' -or $_.subject -match 'MPF' } | select PSParentPath,issuer, subject | Sort-Object PSParentPath,issuer | Format-list
root=>v0; my=>wdgoi, ca => (v0,v0),(v1,v1),(pessoas,v0),(equipamentos,v0)
icp => cu.authroot, cu.root, cu.ca, lm.authroot, lm.root => (v5,v5), (v10,v10)
#>
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

set-Location -Path Cert:\CurrentUser\My
$pwd_secure_string = Read-Host "Enter a Password" -AsSecureString
import-pfxCertificate -FilePath c:\Users\wdgoi\Documents\GD\Meu Drive\cert-wdg\wdgoi@mpf.mp.br.p12' -Password $securestring

<#

set-Location -Path Cert:\CurrentUser\Root\
Import-Certificate -FilePath 'C:\Users\wdgoi\Documents\GD\Meu Drive\manuais\certificado-vpn\AutoridadeCertificadoraRaizInternaMPFv0.crt'
Import-Certificate -FilePath 'C:\Users\wdgoi\Documents\GD\Meu Drive\manuais\certificado-vpn\icpbrasilv10.crt' 
Import-Certificate -FilePath 'C:\Users\wdgoi\Documents\GD\Meu Drive\manuais\certificado-vpn\icpbrasilv5.crt'
set-Location -Path Cert:\CurrentUser\CA\
import-Certificate -FilePath 'C:\Users\wdgoi\Documents\GD\Meu Drive\manuais\certificado-vpn\ACEquipamentosMPFv0.crt'
import-Certificate -FilePath 'C:\Users\wdgoi\Documents\GD\Meu Drive\manuais\certificado-vpn\ACPessoasMPFv0.crt'
Import-Certificate -FilePath 'C:\Users\wdgoi\Documents\GD\Meu Drive\manuais\certificado-vpn\AutoridadeCertificadoraRaizInternaMPFv0.crt'
Import-Certificate -FilePath 'C:\Users\wdgoi\Documents\GD\Meu Drive\manuais\certificado-vpn\icpbrasilv10.crt' 
Import-Certificate -FilePath 'C:\Users\wdgoi\Documents\GD\Meu Drive\manuais\certificado-vpn\icpbrasilv5.crt'
set-Location -Path Cert:\CurrentUser\AuthRoot\
Import-Certificate -FilePath 'C:\Users\wdgoi\Documents\GD\Meu Drive\manuais\certificado-vpn\icpbrasilv10.crt' 
Import-Certificate -FilePath 'C:\Users\wdgoi\Documents\GD\Meu Drive\manuais\certificado-vpn\icpbrasilv5.crt'
Set-Location -Path Cert:\LocalMachine\AuthRoot
Import-Certificate -FilePath 'C:\Users\wdgoi\Documents\GD\Meu Drive\manuais\certificado-vpn\icpbrasilv10.crt' 
Import-Certificate -FilePath 'C:\Users\wdgoi\Documents\GD\Meu Drive\manuais\certificado-vpn\icpbrasilv5.crt'
Set-Location -Path Cert:\LocalMachine\Root
Import-Certificate -FilePath 'C:\Users\wdgoi\Documents\GD\Meu Drive\manuais\certificado-vpn\icpbrasilv10.crt' 
Import-Certificate -FilePath 'C:\Users\wdgoi\Documents\GD\Meu Drive\manuais\certificado-vpn\icpbrasilv5.crt'



& 'C:\Users\wdgoi\Documents\GD\Meu Drive\manuais\certificado-vpn\forcepoint-cliente.exe'

#>
