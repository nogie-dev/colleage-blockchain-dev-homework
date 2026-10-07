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

## Solidity 데이터 타입 실습

지정된 강의자료 페이지마다 독립된 컨트랙트 파일을 두었습니다. Remix에서 저장소를 불러온 뒤 Solidity `0.8.20`과 `Remix VM`을 선택하고, 각 파일을 컴파일한 다음 해당 컨트랙트를 배포하면 됩니다.

| 자료 페이지 | 파일 | Remix에서 확인할 순서 |
| --- | --- | --- |
| 4 | `contracts/solidity-data-types/CampaignFlag.sol` | `activate` → `isOpen`이 `true`; `finalize` → `isOpen`이 `false`, `succeeded`가 `true` |
| 6 | `Counter.sol` | `inc(3)` → `count=3`, `delta=3`; `dec(1)` → `count=2`, `delta=2`; `dec(5)`는 revert |
| 7 | `AddressTypes.sol` | Account 2 주소로 배포; `inspectDonor()`로 balance/codehash/code 조회; Account 3에서 Value `1 ether`로 `deposit`; 배포 계정에서 `sendToBeneficiary(1000000000000000000)` |
| 10 | `CampaignRegistry.sol` | `code`에 bytes32 값, `category`에 `1`을 넣어 배포; `category=1`, `isHealth=true` 확인 |
| 13 | `DonorBook.sol` | Account 3에서 `1 ether`, Account 4에서 `0.5 ether` 기부; Account 3에서 `refund(300000000000000000)`; 누적 기부액은 `1.5 ether`, Account 3 기록은 `0.7 ether` |
| 14 | `CampaignDonations.sol` | Account 3과 Account 4가 같은 캠페인 ID로 각각 기부; `campaignsById(campaignId, donor)`로 주소별 값 조회 |
| 16 | `CampaignRoster.sol` | `open(1)`, `open(7)`, `open(4)` → `[1,7,4]`; `swapRemove(1)` → `[1,4]`; `closeLast` → `[1]` |
| 19 | `ProfileBook.sol` | Account 3에서 `join("kim")`, `addScore(5)`, `addScore(3)`; `getProfile(Account 3)` → `kim`, `8`; Account 4는 별도 프로필 |

기부 함수의 Value는 Remix에서 ETH 단위를 선택합니다. 반면 페이지 13의 `refund` 인자는 Solidity `uint256` wei 값이므로, `0.3 ether` 환불은 `300000000000000000`으로 입력합니다. 코드에 표시된 금액 누적값도 wei 단위입니다.

페이지 4의 `activate()`는 `isOpen()`의 참 조건을 시험하기 위한 작은 실습 보조 함수입니다. 페이지 19의 `getProfile()`도 동적 문자열인 이름까지 Remix에서 확인할 수 있도록 추가했습니다. 나머지 함수와 저장 구조는 자료의 예제를 따릅니다.

## Remix VM 배포 및 테스트 결과

2026-10-07에 Remix VM을 사용해 여덟 컨트랙트를 각각 Solidity `0.8.20`으로 컴파일하고 배포했습니다. 아래는 해당 세션에서 실제로 확인한 결과입니다. Remix VM은 브라우저 세션용 로컬 테스트 환경이므로 이 배포 주소와 상태는 공개 테스트넷에 남지 않습니다.

| 자료 페이지 | 실행한 동작 | 확인 결과 |
| --- | --- | --- |
| 4 | `activate()` → `isOpen()` → `finalize()` → `isOpen()` | `true` 후 `false` |
| 6 | `inc(3)`, `count()`, `delta()`, `dec(1)`, `dec(5)` | `count=3`, `delta=3`; `dec(1)` 성공; 초과 차감은 `n exceeds count`로 revert |
| 7 | Account 2를 수혜자로 배포; `deposit`에 1 ETH; `sendToBeneficiary(1000000000000000000)` | 입금 및 수혜자 송금 트랜잭션 성공 |
| 10 | `category=1`로 배포; `isHealth()` | `true` |
| 13 | Account 1과 Account 2가 각각 1 ETH 기부; Account 2가 0.3 ETH 환불 | Account 2 기록 `0.7 ETH`; 누적 기부액 `2 ETH` |
| 14 | 캠페인 1에 Account 2가 1 wei, Account 1이 2 wei; 캠페인 2에 Account 1이 3 wei 기부 | 주소와 캠페인별 mapping 값 `1`, `2`, `3`; 미기부 조합은 `0` |
| 16 | `open(1)`, `open(7)`, `open(4)`, `swapRemove(1)`, `closeLast()` | 배열 원소가 `[1,7,4]`에서 `[1,4]`, 마지막으로 `[1]`이 되는 것을 확인 |
| 19 | Account 1에서 `join("kim")`, `addScore(5)`, `addScore(3)`, `getProfile(Account 1)` | 이름 `kim`, 점수 `8` |

페이지 13의 표는 실제 테스트 세션의 송금 값을 그대로 기록했습니다. `0.5 ETH` 단위 입력이 필요한 경우 Remix의 Value 단위를 `wei`로 바꾸고 `500000000000000000`을 입력하면 됩니다.
