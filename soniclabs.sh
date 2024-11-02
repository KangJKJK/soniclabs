#!/bin/bash

# 색상 정의
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # 색상 초기화

echo -e "${GREEN}soniclabs 봇을 설치합니다.${NC}"
echo -e "${GREEN}스크립트작성자: https://t.me/kjkresearch${NC}"
echo -e "${GREEN}출처: https://github.com/web3bothub/soniclabs-arcade-bot${NC}"

echo -e "${GREEN}옵션을 선택하세요:${NC}"
echo -e "${YELLOW}1. Soniclabs 봇 새로 설치${NC}"
echo -e "${YELLOW}2. 기존정보 그대로 이용하기(재실행)${NC}"
echo -e "${YELLOW}3. Soniclabs 봇 업데이트${NC}"
read -p "선택: " choice

case $choice in
  1)
    echo -e "${GREEN}Soniclabs를 새로 설치합니다.${NC}"
    # 파이썬 및 필요한 패키지 설치
    echo -e "${YELLOW}시스템 업데이트 및 필수 패키지 설치 중...${NC}"
    rm -rf /root/soniclabs-arcade-bot
    sudo apt update
    sudo apt install -y git

    # GitHub에서 코드 복사
    [ -d "/root/soniclabs-arcade-bot" ] && rm -rf /root/soniclabs-arcade-bot
    echo -e "${YELLOW}GitHub에서 코드 복사 중...${NC}"
    git clone https://github.com/web3bothub/soniclabs-arcade-bot.git

    # 작업 공간 생성 및 이동
    echo -e "${YELLOW}작업 공간 이동 중...${NC}"
    cd /root/soniclabs-arcade-bot

    echo -e "${YELLOW}Node.js LTS 버전을 설치하고 설정 중...${NC}"
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
    export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # nvm을 로드합니다
    nvm install --lts
    nvm use --lts
    npm install
    cp -r accounts/accounts_tmp.js accounts/accounts.js && cp -r config/proxy_list_tmp.js config/proxy_list.js

    # 사용자 정보 입력
    echo -e "${GREEN}사용자 정보를 입력받습니다.${NC}"

    echo -e "${GREEN}봇을 실행하기전에 다음 단계들이 필수적으로 필요합니다. 진행하신 후 엔터를 눌러주세요.${NC}"
    read -p "Faucet을 받아주세요: https://testnet.soniclabs.com/account"
    read -p "플랫폼에 가입을 하세요: https://airdrop.soniclabs.com/?ref=0pyxta"
    read -p "다음 사이트로 이동하세요: https://arcade.soniclabs.com/"
    read -p "같은 지갑을 연결하시고 Step2에서 faucet을 또 받아주세요 (트위터계정필요)"
    read -p "우측 상단에 표시되는 지갑주소가 스마트월렛이 됩니다."
    read -p "Plinko, Mine, Wheel 게임을 최초 한번씩만 플레이를 해주세요"
    
    # 사용자로부터 계정 정보 입력받기
    read -p "프라이빗키를 입력하세요 (쉼표로 구분): " account
    read -p "스마트 월렛 주소를 입력하세요 (쉼표로 구분): " wallet_addresses
    
    # IFS 설정 후 배열 초기화
    IFS=',' read -r -a private_keys <<< "$account"
    IFS=',' read -r -a smart_wallet_addresses <<< "$wallet_addresses"
    
    # .env 파일에 프라이빗키와 스마트 월렛 주소 저장
    {
        echo "PRIVATE_KEYS=${private_keys[*]}"
        echo "SMART_WALLET_ADDRESS=${smart_wallet_addresses[*]}"
    } > /root/soniclabs-arcade-bot/.env
    
    # 프록시 정보 입력 안내
    echo -e "${RED}Civil을 피하기 위해 각 프라이빗키마다 하나씩 프록시가 필요합니다.${NC}"
    echo -e "${YELLOW}프록시 정보를 입력하세요. 입력형식: http://proxyUser:proxyPass@IP:Port${NC}"
    echo -e "${YELLOW}여러 개의 프록시는 쉼표로 구분하세요.${NC}"
    echo -e "${YELLOW}프록시가 없다면 VPS IP로만 이용하게됩니다. 입력형식: http://root:패스워드@VPS IP:VPS port${NC}"
    echo -e "${YELLOW}챗GPT를 이용해서 형식을 변환해달라고 하면 됩니다.${NC}"
    read -p "프록시 정보를 입력하시고 엔터를 누르세요: " proxies
    
    # .env 파일에 프록시 정보 추가
    echo "PROXIES=$proxies" >> /root/soniclabs-arcade-bot/.env
    
    # 필수 진행단계 안내   
    npm run start
    ;;
  2)
    echo -e "${GREEN}Soniclabs를 재실행합니다.${NC}"
    cd /root/soniclabs-arcade-bot
    export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # nvm을 로드합니다
    npm run start
    ;;
  3)
    echo -e "${GREEN}Soniclabs를 업데이트합니다.${NC}"
    cd /root/soniclabs-arcade-bot
    git pull
    git pull --rebase
    git stash && git pull
    npm update
    export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # nvm을 로드합니다
    npm run start
    ;;
  *)
    echo -e "${RED}잘못된 선택입니다. 다시 시도하세요.${NC}"
    ;;
esac
