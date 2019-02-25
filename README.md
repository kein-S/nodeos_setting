# Block chain study
> Fun and New 를 위해 제작되었습니다.

# Block chain 이론
* 간략한 개념 정리

## Block chain 이란?
* 거래기록(transaction)을 나눠서 저장.
* 거래기록 ex) `누가`, `누구에게`, `언제`, `얼마나`, 등등
* 거래기록을 저장 할 수 있는 Block 의 생산방식은 합의(consensus) 알고리즘에 따라 다름.
* 보통의 경우 Block 생성에 대한 보상으로 코인이 발행됨.
* 대표적인 합의 알고리즘
> POW(Proof-of-work), POS(Proof-of-stake), DPOS(Delegated Proof-of-Stake)

## 1세대 비트코인
* POW
* 화폐로서 가치
* Transaction 느림, Block 을 생산하기 위한 hash 값을 맞추는데 너무 많은 자원이 소모됨.

## 2세대 이더리움
* POW / POS
* Smart contract (Solidity 사용)
* 여전히 느림, 제한적인 리소스, Dapp 이용에 수수료가 듬.

## 3세대 이오스
* DPOS
* 빠름
* Smart contract (WASM 사용)
* Dapp 이용에 수수료 없음, 개발사가 리소스 할당에 EOS 를 묶어둠.
* 빠름, 불안정, 완전한 탈중화라고 볼 수 없음, Account 생성이 어렵고 유료임.

# EOS 에 대해서
* Dan larimer 가 개발
* `21` 개의 `Block producer` 가 block을 생산 [비잔티움 장애 허용 - EOSYS Orchid Kim 님 번역](https://medium.com/eosys/dpos-bft-%ED%8C%8C%EC%9D%B4%ED%94%84%EB%9D%BC%EC%9D%B8-%EB%B9%84%EC%9E%94%ED%8B%B4-%EC%9E%A5%EC%95%A0-%ED%97%88%EC%9A%A9-4882fa66268a)
* 21 개의 BP 선정은 투표를 통해 선정함
* 투표는 1 EOS 이상을 가진 모든 계정이 참여 할 수 있음.
* 자원
- **CPU / Network**
* Transaction 발생시 사용됨.
- **RAM**
* Smart contract 내의 DB


# 실습

## 실습환경 구성
* Install EOSIO [Step 1](https://developers.eos.io/eosio-home/docs/setting-up-your-environment#section-step-1-install-binaries)

* 테스트
```
nodeos //node daemon
keosd //wallet daemon
cleos //cammand line tool
```

* 스크립트 다운로드
```shell
mkdir eosnode
cd eosnode
git clone https://github.com/kein-S/nodeos_setting .
```

* Local Node Test
```shell
./start.sh
tail -f stderr.txt
./stop.sh
```

## 구성요소 설명
* nodeos
> 블록체인 코어 데몬
api 제공 / 블록 생산

* keosd
> 지갑 데몬, cleos 를 이용하여 사용함.
private key 보관 / private key 를 이용한 sign 제공

* cleos
> command line tool
> keosd 를 활용하여 nodeos 에 api 요청을 하는 기능


## 계정 생성
* Account name 규칙: 알파벳소문자, 1~5, .
* 생성해줄 사람이 존재해야함.
* Private chain 에서는 직접 eosio 의 계정으로 다른 계정을 생성 가능하다.

1. eosio 계정의 private key import [링크](https://developers.eos.io/eosio-cleos/reference#cleos-wallet-import)

* Test 용 eosio 계정의 키패어는 다음과 같다
```
pubic key: EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
private key: 5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3
```

* 다음을 이용해서 eosio 계정의 private key 를 wallet 에 import 한다.
```shell
cleos wallet create -n testwallet --to-console
cleos wallet import --private-key 5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3
cleos wallet unlock -n testwallet
```

2. `cleos` 를 이용한 계정 생성 [링크](https://developers.eos.io/eosio-cleos/reference#cleos-create-account)

* 사용할 키패어 생성
```shell
cleos create key --to-console
```

* `funandnewbp1` 계정을 생성해본다.
```shell
cleos create account [OPTIONS] creator name OwnerKey ActiveKey -p eosio
cleos create account eosio funandnewbp1 {Pubkey} {Pubkey} -p eosio
```

* `funandnewbp1` 계정을 생성해본다.
* `eosio.token` 계정을 생성해본다.
```shell
cleos create account eosio eosio.token EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV -p eosio
```

## 토큰 생성해보기
* EOS 의 토큰은 smart contract 로 제작 되어있다. 토큰을 생성하기 위해 smart contract 개발툴을 다운로드 받는다.

1. eosio cdt 다운로드 [링크](https://developers.eos.io/eosio-home/docs/installing-the-contract-development-toolkit)

2. eos system contract 다운로드 [링크](https://developers.eos.io/eosio-home/docs/token-contract)
```shell
git clone https://github.com/EOSIO/eosio.contracts --branch v1.4.0 --single-branch
```

3. eosio.token contract 빌드
eosio-cpp -I include -o eosio.token.wasm src/eosio.token.cpp --abigen

4. contract deploy
```shell
cleos set contract eosio.token {CONTRACT_DIR}/eosio.contracts/eosio.token --abi eosio.token.abi -p eosio.token@active
```
5. 토큰 생성
```shell
cleos push action eosio.token create '["eosio", "1000000000.0000 EOS"]' -p eosio.token@active
```

6. 토큰 발행
```shell
cleos push action eosio.token issue '[ "funandnewbp1", "10000.0000 EOS", "issue" ]' -p eosio@active
cleos get currency balance eosio.token funandnewbp1 EOS
```

7. 토큰 전송해보기
```shell
cleos push action eosio.token transfer '["funandnewbp1", "funandnewbp2", "10.0000 EOS", "test"]' -p funandnewbp1@active
cleos get currency balance eosio.token funandnewbp1 EOS
```

# 실전

## 노드 초기화
```shell
cd eosnode
./stop.sh
rm -rf ./data
```

## EOS Block chain 을 통한 multi-node 구성
1. genesis block 을 생산할 node 를 정한다.

2. node start
```shell
./start.sh
```

3. `funandnewbp0` 계정 생성
* 지갑생성
* eosio 계정의 private key import
* cleos 를 이용해서 계정생성

4. 노드 정지

5. config.ini 수정
```
producer-name = funandnewbp0
signature-provider = {funandnewbp0의 퍼블릭키}=KEY:{funandnewbp0의 프라이빗키}
http-server-address = {IP 주소}:{포트}
```

6. 노드 재시작

7. genesis.json 배포

8. `funandnewbp1`, `funandnewbp2`, `funandnewbp3` ... 생성.
* 각자의 서버에서 키패어 생성
* 퍼블릭키를 `funandnewbp0` 에게 알려주어 계정 생성
* IP 주소 공유
* `funandnewbp0`와 마찬가지로 config.ini 수정
* 서로의 IP 주소를 config.ini 하단에 기록
```
p2p-peer-address: {funandnewbp1 의 IP 주소}:{포트}
p2p-peer-address: {funandnewbp2 의 IP 주소}:{포트}
p2p-peer-address: {funandnewbp3 의 IP 주소}:{포트}
```

11. 토큰 제작 / 발행 / 테스트 실습
>주의!!
```shell
cleos -u {노드IP:포트} 명령어
```
를 사용해야함.

## Smart contract

### Smart contract 제작
```shell
cd eosionode/contracts/door
eosio-cpp -abigen door.cpp -o door.wasm
```

### Smart contract 배포

* 계정생성
doortestdoor

```shell
cleos -u {노드IP:포트} set contract {생성계정} {절대경로/eosnode/contract/door} -p {생성계정}@active
```

### Smart contract  테스트
```shell
cleos -u {노드IP:포트} push action doortestdoor enter '["funandnewbp1"]' -p funandnewbp1@active //실행됨.
cleos -u {노드IP:포트} push action doortestdoor enter '["funandnewbp0"]' -p funandnewbp1@active //권한이 없음.
```


## Q & A
