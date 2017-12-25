# 1. 무엇인가요?
## 알람시간에 맞추어 전기장판등을 켜고 끄는 앱입니다.
1. 잠든 뒤 **N분** 후에 전기장판을 끕니다.
2. 자는 동안에는 움직임을 기록하여 그래프를 그립니다.
3. 기상시간 **N분** 전 전기장판을 켭니다.
4. 기상시간에 맞추어 알람을 울립니다.
5. [데모영상](http://blog.e-sung.net/RaspberryPiAlarm.mp4)

# 2. 어떻게 설치하나요?
* `git clone https://github.com/e-sung/RaspberryAlarm.git`
* `cd RaspberryAlarm`
* `pod install`
* `open RaspberryAlarm.xcworkspace`
* [라즈베리파이에 설치할 서버](https://github.com/e-sung/RaspberryAlarm-Server) 설치

# 3. 문서화
* `jazzy --min-acl private`

# 4. 어떤 기능이 추가될 예정인가요?
* 기상시간 N분 전 부터 서서히 알람소리 커지기
* 수면데이터 Health-Kit 과 연동
* 수면데이터를 바탕으로 RAM 수면주기  파악->RAM 수면 중 기상알람 울리기
* 기상시간 전후로 N곳에 M개의 HTTP 요청 보내기 

### Pull-Request 및 Issue 제기는 언제나 환영입니다!
	
