#Information Gathering

## Scansione IP

### Scansione di tutti gli IP su un network tramite la tabella ARP

```
arpscan -I <interfaccia> --localnet
```

### Scansione di tutti gli IP tramite ping

```
netdiscover -i <interfaccia>
```

### Enumerazione sottodomini

```
ffuf -w /path/to/wordlist.txt -u https://FUZZ.esempio.com -mc 200,204,301,302,307,403
```

- `-w` Dizionario utilizzato per i sottodomini
- `-u` path con `FUZZ` dove provare il bruteforce
- `-mv` Riporta gli stati di risposta accettati

## Scansione Porte

### Scansione di tutte le porte

```
nmap -p- -sCV --open -T5 -Pn <ip_target> -oN file.nmap -vvv
```

- `-p-` Scansiona tutte le porte
- `-s` Scansiona
- `-V` rileva le versioni dei server
- `-C` check di eventuali vulnerabilità
- `-T5` Velocità scansione INSANE
- `-Pn` indica a nmap di non eseguire il ping
- `-oN` file.nmap esporta in un file normale
- `-vvv` Imposta il livello di verbose al massimo

### Scansione delle sole porte aperte

```
nmap -p22,80 -T5 -sVC <ip_target> -oN file.ports.nmap
```

- -p22,80 Scansiona solo le porte 22 e 80
- -s Scansiona
- -V rileva le versioni dei server
- -C check di eventuali vulnerabilità
- -T5 Velocità scansione INSANE
- -oN file.nmap esporta in un file normale

## http-enum

### Scansione le path http enumerandole tramite nmap

```
nmap --script http-enum -p80 -T5 <ip_target>
```

### Scansiona delle path tramite gobuster

```
gobuster dir -u http://target -w /usr/share/SecLists/Discovery/Web-Content/directory-list-2.3-medium.txt
```

- `dir` prova tutte le directori
- `-u` directory http del target
- `-w` dizionario di forza bruta

### Scansiona delle path tramite ffuf

```
ffuf -w /usr/share/wordlists/seclists/big.txt -u http://10.10.73.154/FUZZ
```

- `-u` directory http del target
- `-w` dizionario di forza bruta
- `FUZZ` variabile dove sostutuire le parole del dizionario

## GET POST DELETE e PUL da terminale

### GET request

```
curl -s -X GET http://<ip_target>/robots.txt
```

- `-s` modalità silenziosa (non visualizza errori)
- `-X` specifica il metodo HTTP da utilizzare per la richiesta

### POST request

```
curl -s -X POST https://example.com/api -H "Content-Type: application/json" -d '{"key1":"value1", "key2":"value2"}'
```

- `-s` modalità silenziosa (non visualizza errori)
- `-X` specifica il metodo HTTP da utilizzare per la richiesta
- `-H` specifica il Content Type
- `-d` specifica i dati da inviare

## Bruteforce

### Bruteforce web (hydra)

```
hydra -l admin -P /usr/share/wordlists/rockyou.txt <ip_target / domain_target> http-post-form "/login.php:username=^USER^&password=^PASS^:Wrong" -IV -t 64
```

- `-l` utente per il bruteforce
- `-P` wordlist da usare per il bruteforce delle password
- `http-post-form` Tipo di richiesta

```
hydra -l user -P /usr/share/wordlists/rockyou.txt <ip_target> ssh
```

- `-l` utente per il bruteforce
- `-P` wordlist da usare per il bruteforce delle password
- `ssh` Tipo di richiesta

## Risorse utils

- /usr/share/wordlists/dirbuster/directory-list-lowercase-2.3-medium.txt
