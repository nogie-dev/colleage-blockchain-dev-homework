# 블록체인 개발 과제: 기부 dApp

`SimpleDonation.sol`은 한 개의 기부 캠페인을 관리하는 Solidity 컨트랙트입니다. 운영자(owner)는 모금을 켜고 끄거나 수혜자를 바꿀 수 있고, 수혜자(beneficiary)는 모인 ETH를 출금할 수 있습니다. 기부자(donor)는 별도 등록 없이 ETH를 보내고 자신의 누적 기부액을 확인할 수 있습니다.

## Remix에서 컴파일하고 배포하기

1. [Remix IDE](https://remix.ethereum.org/)를 열고 `contracts/SimpleDonation.sol`을 새 파일에 복사합니다.
2. Solidity Compiler에서 버전 `0.8.20`을 선택해 컴파일합니다.
3. Deploy & Run에서 Environment를 `Remix VM`으로 선택합니다.
4. Account 1을 선택하고 생성자 입력란에 Account 2 주소를 넣어 Deploy합니다. 배포 계정(Account 1)이 owner가 되고 Account 2가 beneficiary가 됩니다.

## Remix VM 실습 순서

1. Account 3을 선택하고 Value를 `1 ether`로 설정한 뒤 `donate`를 호출합니다.
2. Account 4로 바꾸고 Value를 `2 ether`로 설정해 다시 `donate`를 호출합니다.
3. Account 3에서 `getMyDonationInEther`는 `1`, `getTotalDonatedInEther`는 `3`, `getContractBalanceInEther`는 `3`인지 확인합니다.
4. Account 1(owner)에서 `setCampaignActive(false)`를 호출하고, 기부가 중단되는지 확인합니다.
5. Account 3에서 `withdraw`를 호출하면 권한 오류가 나야 합니다. Account 2(beneficiary)로 바꿔 `withdraw`를 호출하면 컨트랙트 잔액은 `0`, 누적 기부액은 `3`으로 남습니다.

`totalDonated`와 주소별 `donations`는 누적 기록입니다. 조회 함수의 Ether 반환값은 소수점 이하를 버리므로, 작은 단위의 기부액 확인에는 공개 변수 `totalDonated` 및 `donations`의 wei 값을 사용합니다.

## 제출 저장소

GitHub: https://github.com/nogie-dev/colleage-blockchain-dev-homework
