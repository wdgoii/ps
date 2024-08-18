get-childitem Cert:\ -recurse | Where-Object {$_.Issuer -match 'Certificadora Raiz Interna MPF'} | Remove-Item -Force
get-childitem Cert:\ -recurse | Where-Object {$_.Issuer -match 'O=ICP-Brasil'} | Remove-Item -Force

$data = get-childitem Cert:\ -recurse | Where-Object {$_.Issuer -match 'O=ICP-Brasil'} | select-object pspath, thumbprint
$data | foreach-object { remove-item $_.pspath -Confirm:$false }
$data = get-childitem Cert:\ -recurse | Where-Object {$_.Issuer -match 'Certificadora Raiz Interna MPF'} | select-object pspath, thumbprint
$data | foreach-object { remove-item $_.pspath -Confirm:$false }

$data = get-childitem Cert:\ -recurse -ExpiringInDays 0  | select-object pspath, thumbprint
$data | foreach-object { remove-item $_.pspath -Confirm:$false }
    
Import-Certificate -FilePath "$env:USERPROFILE\downloads\AutoridadeCertificadoraRaizInternaMPFv0.crt" -CertStoreLocation "Cert:\CurrentUser\Root"
Import-Certificate -FilePath "$env:USERPROFILE\downloads\icpbrasilv5.crt" -CertStoreLocation "Cert:\CurrentUser\Root"
Import-Certificate -FilePath "$env:USERPROFILE\downloads\icpbrasilv10.crt" -CertStoreLocation "Cert:\CurrentUser\Root"

Import-Certificate -FilePath "$env:USERPROFILE\downloads\AutoridadeCertificadoraRaizInternaMPFv1.crt" -CertStoreLocation "Cert:\CurrentUser\CA"
Import-Certificate -FilePath "$env:USERPROFILE\downloads\ACEquipamentosMPFv0.crt" -CertStoreLocation "Cert:\CurrentUser\CA"
Import-Certificate -FilePath "$env:USERPROFILE\downloads\ACPessoasMPFv0.crt" -CertStoreLocation "Cert:\CurrentUser\CA"