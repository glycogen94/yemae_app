# 공연 예매 앱 개발 계획 (가칭: yemae_app)

**1. 개요 및 목표:**
*   **목표:** 공연/콘서트 예매 시 발생하는 매크로 등 부정 예매의 어려움 속에서도, 사용자에게 비교적 공정하고 편리한 예매 경험을 제공한다.
*   **타겟 사용자:** 콘서트, 팬미팅, 뮤지컬 등 특정 이벤트 티켓을 구매하려는 팬 또는 일반 사용자.
*   **성공 지표 (예시):** 앱 다운로드 수, 예매 성공률, 사용자 평점, 특정 시간 내 예매 처리 속도 등.

**2. 주요 기능 (요구사항):**
*   **사용자 인증:**
    *   이메일/비밀번호 또는 소셜 로그인을 통한 회원가입 및 로그인 기능.
    *   (선택) 본인 인증 기능 (부정 예매 방지를 위한 고려 사항).
*   **공연 정보 탐색:**
    *   진행 중/예정된 공연 목록 보기 (포스터, 제목, 날짜, 장소).
    *   카테고리별 필터링 (콘서트, 뮤지컬, 연극 등).
    *   공연 제목, 아티스트 등으로 검색 기능.
*   **공연 상세 정보:**
    *   공연 상세 설명, 출연진, 공연 시간, 장소 지도 보기.
    *   티켓 오픈 일정 알림 신청 기능 (선택).
    *   좌석 등급 및 가격 정보 확인.
    *   (구현 가능 시) 실시간 잔여 좌석 수 표시.
*   **좌석 선택:**
    *   (가능하다면) 인터랙티브 좌석 배치도에서 좌석 선택.
    *   (또는) 구역/등급별 잔여 좌석 목록에서 선택.
    *   선택한 좌석 임시 확보 (일정 시간 동안 유효).
*   **예매 및 결제:**
    *   선택한 좌석 정보 확인 및 예매 진행.
    *   결제 수단 연동 (신용카드, 간편결제 등 - 외부 PG사 연동 필요).
    *   예매 완료 및 확인 화면 표시.
*   **내 예매 관리:**
    *   예매 내역 목록 확인 (공연 정보, 좌석 정보, 결제 금액 등).
    *   (정책에 따라) 예매 취소 기능.
    *   모바일 티켓 또는 QR 코드 확인 기능.
*   **알림:**
    *   티켓 오픈 알림 (신청 시).
    *   예매 완료 알림.
    *   공연 임박 알림.

**3. 디자인 및 UI/UX 고려사항:**
*   직관적이고 사용하기 쉬운 인터페이스.
*   티켓 오픈 시 많은 트래픽을 견딜 수 있는 디자인 (간결함 중시).
*   플랫폼(Flutter)의 장점을 살린 부드러운 애니메이션 및 사용자 경험.

**4. 비기능적 요구사항 (간략히):**
*   **성능:** 티켓 오픈 시에도 안정적인 응답 속도 유지.
*   **확장성:** 사용자 및 공연 수가 증가해도 시스템 확장이 용이해야 함 (Firebase 장점).

## 개발 단계

**기호:**
*   `[x]` : 완료 (Completed)
*   `[~]` : 진행 중 (In Progress)
*   `[ ]` : 예정 (Pending)

---

### Phase 1: 사용자 인증 구현 (Flutter)

*   **[x] 1. Firebase 설정 (Flutter)**
    *   `[x]` `pubspec.yaml`에 Firebase 관련 패키지 추가 (`firebase_core`, `firebase_auth`)
    *   `[x]` `flutter pub get` 실행
    *   `[x]` Firebase 프로젝트 연결 설정 (`firebase_options.dart` 생성/업데이트)
*   **[x] 2. UI 개발 및 Firebase Auth 연동 (Flutter)**
    *   `[x]` `lib` 폴더 내 기본 구조 생성 (`screens`, `widgets`)
    *   `[x]` `screens/login_screen.dart` 파일 생성 (회원가입 기능 포함)
    *   `[x]` 로그인/회원가입 화면 기본 UI 구현 (이메일, 비밀번호 필드, 버튼)
    *   `[x]` `main.dart`에서 Firebase 초기화 (`Firebase.initializeApp`)
    *   `[x]` `FirebaseAuth`를 사용한 회원가입 (`createUserWithEmailAndPassword`) 로직 구현
    *   `[x]` `FirebaseAuth`를 사용한 로그인 (`signInWithEmailAndPassword`) 로직 구현
    *   `[x]` 로그인 상태에 따른 화면 전환 로직 구현 (`main.dart`의 `AuthWrapper`)
    *   `[x]` 이메일/비밀번호 필드 비어 있을 때 검증 로직 추가
*   **[x] 3. 테스트**
    *   `[x]` 에뮬레이터/기기에서 회원가입 및 로그인 기능 테스트 (기본 시나리오)
    *   `[x]` Firebase 콘솔에서 사용자 생성 확인

### Phase 2: 데이터 모델링 및 기본 화면 (Firestore & Flutter)

*   **[x] 1. Firestore 데이터 모델링**
    *   `[x]` Firestore 컬렉션 구조 정의 (`users`, `events`, `venues`, `bookings`, `seats` 등) -> 우선 `events` 시작
    *   `[x]` Firebase 콘솔에서 테스트용 `events` 데이터 수동 추가
*   **[x] 2. Firestore 연동 (Flutter)**
    *   `[x]` `pubspec.yaml`에 `cloud_firestore` 패키지 추가 및 `flutter pub get` 실행
    *   `[x]` `screens/home_screen.dart`, `screens/event_detail_screen.dart` 생성/수정
    *   `[x]` `home_screen`에서 Firestore `events` 컬렉션 데이터 로드 및 목록 표시
    *   `[x]` 목록 항목 탭 시 `event_detail_screen`으로 `eventId` 전달 및 이동 구현
    *   `[x]` `event_detail_screen`에서 `eventId`로 공연 상세 정보 로드 및 표시
*   **[x] 3. Firestore 보안 규칙 설정**
    *   `[x]` Firebase 콘솔에서 기본적인 Firestore 보안 규칙 설정 (예: 로그인 사용자 읽기 권한)
*   **[x] 4. 테스트**
    *   `[x]` 앱에서 테스트 공연 목록 및 상세 정보 정상 표시 확인

### Phase 3: 기본 Cloud Function 작성 (Backend - Functions)

*   **[x] 1. Functions 설정**
    *   `[x]` `functions` 디렉토리 설정 및 필수 패키지 설치 (`firebase-admin`, `firebase-functions`, `typescript` 등)
*   **[ ] 2. 첫 번째 함수 작성 (TypeScript 권장)**
    *   `[x]` `index.ts` 파일에 `initializeApp` 설정
    *   `[x]` 간단한 테스트용 HTTP 함수 (`helloWorld`) 작성 및 배포/테스트
    *   `[x]` 기본적인 예매 요청 처리 Callable Function (`requestBooking`) 구조 작성 (인증 확인 포함, 로직은 추후 구현)
*   **[ ] 3. 테스트**
    *   `[ ]` Firebase 에뮬레이터 또는 실제 배포 후 함수 호출 테스트
