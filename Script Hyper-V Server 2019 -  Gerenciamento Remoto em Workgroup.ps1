# Script Hyper-V Server 2019 -  Gerenciamento Remoto em Workgroup - Créditos Gabriel Luiz - www.gabrielluiz.com ##


# Alterar o sufixo DNS primário do servidor Hyper-V.


Get-DnsClient # Verificar qual é o índice da interface de rede.

Set-DnsClient -InterfaceIndex 4 -ConnectionSpecificSuffix "replicar.local" # Adicionar o sufixo DNS especificado.



# Teste de conexão Remota Powershell.


Enter-PSSession -ComputerName SR1.replicar.local


# Adicionar as entradas HOSTS´s e FQDN ao arquivo hosts.


Get-Content -Path "C:\Windows\System32\drivers\etc\hosts" # Verfica quais são as entradas no arquivos hosts.

Add-Content -Path "C:\Windows\System32\drivers\etc\hosts" -Value "192.168.0.131 SR1.replicar.local" # Adiciona a entrada no arquivo hosts.

Add-Content -Path "C:\Windows\System32\drivers\etc\hosts" -Value "192.168.0.131 W10.replicar.local" # Adiciona a entrada no arquivo hosts.

# Obervação:

# Este comando também deve ser executado também no servidor Hyper-V.


# Abrir as porta do firewall para o ping entre servidor e cliente.


Enable-NetFirewallRule -DisplayName "File and Printer Sharing (Echo Request - ICMPv4-In)" # Libera a porta ICPv4 Solicitação de Eco correspondente em Inglês.

Enable-NetFirewallRule -DisplayName "Compartilhamento de Arquivo e Impressora (Solicitação de Eco - ICMPv4-In)" # Libera a porta ICPv4 Solicitação de Eco correspondente em Português.

Enable-NetFirewallRule -DisplayName "File and Printer Sharing (Echo Request - ICMPv6-In)" # Libera a porta ICPv6 Solicitação de Eco correspondente em Inglês.

Enable-NetFirewallRule -DisplayName "Compartilhamento de Arquivo e Impressora (Solicitação de Eco - ICMPv6-In)" # Libera a porta ICPv6 Solicitação de Eco correspondente em Português.


# Obervação:

# Este comando também deve ser executado  no servidor Hyper-V 2019 e no Windows 10.



# Altere a Rede de Pública para Privada.


Get-NetConnectionProfile # Verifica em qual perfil de rede estar configurada atualmente.

Set-NetConnectionProfile -InterfaceAlias "Ethernet" -NetworkCategory Private # Altera a perfil da rede para privada.


# Habilitar o gerenciamento remoto.


Enable-PSRemoting


# Obervação:

# Este comando deve ser executado no Windows 10.



# Habilita a delegação para o domínio especificado.


Get-WSManCredSSP  # Verfica a delegação.

Enable-WSManCredSSP -Role Client -DelegateComputer "*.replicar.local" # Adcionar o seguinte destino a delegação.



# Adicionar o domínio ao hosts confiáveis.


Get-Item -Path WSMan:\localhost\Client\TrustedHosts # Verfica os hosts confiáveis.

Set-Item -Path WSMan:\localhost\Client\TrustedHosts -Value "*.replicar.local" # Adiciona o domínio especificado ao hosts confiáveis.


# Adiciona a credencial especificada ao computador.


cmdkey /list # Lista as credenciais. 

cmdkey /add:SR1.replicar.local /user:Administrator /pass:@abc123 # Adiciona a credencial especificada ao computador.


# Teste de conexão Remota Powershell ( Verficar se realemnte a configuração estar funcionando).

Enter-PSSession -ComputerName SR1.replicar.local