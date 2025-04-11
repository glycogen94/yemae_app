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

### Phase 1: 사용자 인증 구현 (Flutter)

1.  **Firebase 설정 (Flutter):**
    *   `yemae_app/pubspec.yaml` 파일에 Firebase 관련 Flutter 패키지를 추가합니다:
        ```yaml
        dependencies:
          flutter:
            sdk: flutter
          firebase_core: ^latest # Firebase 코어
          firebase_auth: ^latest # Firebase 인증
          # 나중에 추가될 것들: cloud_firestore, cloud_functions, firebase_storage, firebase_messaging
        ```
    *   터미널(Studio 내 터미널)에서 `flutter pub get` 실행.
    *   Studio의 Firebase 통합 도구 또는 `flutterfire configure` 명령어를 사용하여 Flutter 앱을 Firebase 프로젝트에 연결하는 설정 파일(예: `firebase_options.dart`)을 생성/업데이트합니다.
2.  **UI 개발 (Flutter):**
    *   `lib` 폴더 아래에 `screens` (또는 `pages`), `widgets` 폴더 구조를 만듭니다.
    *   `screens` 폴더에 `login_screen.dart`, `signup_screen.dart` 파일을 만듭니다.
    *   간단한 이메일, 비밀번호 입력 필드와 버튼이 있는 UI를 구현합니다.
3.  **Firebase Auth 연동 (Flutter):**
    *   `main.dart`에서 Firebase를 초기화합니다 (`await Firebase.initializeApp(...)`).
    *   `login_screen.dart`, `signup_screen.dart`에서 `FirebaseAuth.instance`를 사용하여 회원가입 (`createUserWithEmailAndPassword`) 및 로그인 (`signInWithEmailAndPassword`) 로직을 구현합니다.
    *   로그인 상태에 따라 홈 화면 또는 로그인 화면으로 이동하는 로직을 `main.dart` 또는 별도의 `auth_wrapper.dart` 등에서 구현합니다.
4.  **테스트:** Studio의 에뮬레이터/기기에서 앱을 실행하여 회원가입 및 로그인이 정상적으로 작동하는지 확인합니다. Firebase 콘솔의 Authentication 탭에서도 사용자 생성을 확인할 수 있습니다.

### Phase 2: 데이터 모델링 및 기본 화면 (Firestore & Flutter)

1.  **Firestore 데이터 모델링:**
    *   앞서 논의한 ERD/PRD를 바탕으로 Firestore 컬렉션 구조를 결정합니다.
        *   `users/{userId}` (Auth 생성 UID 사용)
        *   `events/{eventId}`
        *   `venues/{venueId}`
        *   `bookings/{bookingId}`
        *   (좌석 관리) `events/{eventId}/seats/{seatId}` (하위 컬렉션) 또는 `events/{eventId}` 문서 내 `seat_map` 필드 등
    *   Firebase 콘솔에서 수동으로 `events` 컬렉션에 테스트용 공연 데이터 몇 개를 추가합니다. (제목, 날짜, 장소 ID 등)
2.  **Firestore 연동 (Flutter):**
    *   `pubspec.yaml`에 `cloud_firestore: ^latest` 추가하고 `flutter pub get` 실행.
    *   `screens` 폴더에 `home_screen.dart` (또는 `event_list_screen.dart`), `event_detail_screen.dart` 생성.
    *   `home_screen.dart`에서 `FirebaseFirestore.instance.collection('events').get()` 또는 `snapshots()`를 사용하여 공연 목록을 가져와 `ListView` 등으로 표시합니다.
    *   목록 항목을 탭하면 해당 `eventId`를 가지고 `event_detail_screen.dart`로 이동하도록 구현합니다.
    *   `event_detail_screen.dart`에서 전달받은 `eventId`로 특정 공연 문서를 가져와 상세 정보를 표시합니다.
3.  **Firestore 보안 규칙 설정:**
    *   Firebase 콘솔의 Firestore Rules 탭에서 기본적인 보안 규칙을 설정합니다. (예: 로그인한 사용자만 `events` 읽기 가능)
    *   `allow read: if request.auth != null;`
4.  **테스트:** 앱을 실행하여 Firestore에 넣은 테스트 공연 데이터가 홈 화면 목록에 잘 표시되는지, 상세 화면으로 이동하여 정보가 잘 보이는지 확인합니다.

### Phase 3: 기본 Cloud Function 작성 (Backend - Functions)

1.  **Functions 설정:**
    *   `functions` 디렉토리로 이동합니다. (Studio 내 탐색기 사용)
    *   `package.json` 파일에 필요한 패키지를 추가합니다 (`firebase-admin`, `firebase-functions`).
    *   `npm install` (또는 `yarn install`) 실행.
2.  **첫 번째 함수 작성:**
    *   `index.js` (또는 `index.ts` - TypeScript 사용 권장) 파일에 간단한 HTTP 호출 가능 함수를 작성합니다.

    ```typescript
    // 예시: functions/src/index.ts
    import * as functions from "firebase-functions";
    import * as admin from "firebase-admin";

    admin.initializeApp();

    // 간단한 테스트 함수
    export const helloWorld = functions.https.onRequest((request, response) => {
      functions.logger.info("Hello logs!", {structuredData: true});
      response.send("Hello from yemae_app backend!");
    });

    // 예매 요청 함수 (초기 버전)
    export const requestBooking = functions.https.onCall(async (data, context) => {
      // 인증된 사용자만 호출 가능하도록 확인 (onCall 사용 시 자동)
      if (!context.auth) {
        throw new functions.https.HttpsError('unauthenticated', 'User must be logged in.');
      }

      const userId = context.auth.uid;
      const eventId = data.eventId;
      const seatId = data.seatId;

      functions.logger.info(`Booking request received: userId=${userId}, eventId=${eventId}, seatId=${seatId}`);

      // TODO: 실제 Firestore 트랜잭션 로직 추가 (Phase 5)

      // 임시 성공 응답
      return { success: true, message: "Booking request received (logic pending)." };
    });
    ```
