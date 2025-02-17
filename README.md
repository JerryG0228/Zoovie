[![MIT License][license-shield]][license-url]
# 🍿프로젝트 이름

> ZOOVIE
<br/>

## ✨메인 기능

- 사용자 등록 및 로그인 기능
- 영화 및 TV 프로그램에 대한 정보 제공
  1. 포스터
  2. 키워드
  3. 관련 영상
  4. 스틸컷
  5. 줄거리
  6. 주요 출연진
  7. 비슷한 영화
  8. 스트리밍 플랫폼
- 영화 및 TV 프로그램 북마크 기능
- 검색 기능 제공

<br/>

## 📱구현 화면

https://github.com/user-attachments/assets/95a4a29e-6f0f-4d31-b4dd-3384e6c06cec


<table>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/08101dc4-810b-4b51-aa0b-693ae83d67e0" width=400></td>
    <td><img src="https://github.com/user-attachments/assets/f4f45899-b312-4da8-970d-957bd4c52f91" width=400></td>
    <td><img src="https://github.com/user-attachments/assets/cf00ee1d-b6b5-497c-a98f-16781827424b" width=400></td>
  </tr>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/0c169a00-b03e-47e8-a443-21d1bb59970f" width=400></td>
    <td><img src="https://github.com/user-attachments/assets/f18ee482-c2b7-4f5f-9372-b8bb819c9fc6" width=400></td>
    <td><img src="https://github.com/user-attachments/assets/fbb62009-8404-4bcc-9f0e-6dda0ea58fc6" width=400></td>
  </tr>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/9e8f615d-f4e8-451a-b28d-40869a038dd4" width=400></td>
    <td><img src="https://github.com/user-attachments/assets/455d5e62-fba2-4935-8022-4e165a8511cc" width=400></td>
    <td></td>
  </tr>
</table>

<br/>

## 🧰기술 스택

- **서버**: [![Flask][Flask]][Flask-url]
- **데이터베이스**: [![MongoDB][MongoDB]][MongoDB-url]
- **클라이언트**: [![Flutter][Flutter]][Flutter-url]

<br/>

## 🚀 Guideline

* **Setup**

## Server
```sh
git clone https://github.com/JerryG0228/Zoovie.git
cd ./server
pip install -r requirements.txt
python3 app.py
python3 user_service.py
python3 media_service.py
python3 search_service.py
```

## Client
```sh
git clone https://github.com/JerryG0228/Zoovie.git
cd ./Font
flutter doctor
flutter pub get
flutter run
```
<br/>

## :fire: Contributing
Please refer to [CONTRIBUTING.md](https://github.com/JerryG0228/Zoovie/blob/main/CONTRIBUTING.md) for Contribution.

For issues, new functions and requests to modify please follow the following procedure. 🥰

1. Fork the Project
2. Create a Issue when you have new feature or bug, just not Typo fix
3. Create your Feature Branch from dev Branch (`git checkout -b feat/Newfeature`)
4. Commit your Changes (`git commit -m 'feat: add new feature'`)
5. Push to the Branch (`git push origin feat/Newfeature`)
6. Open a Pull Request to dev branch with Issues

<br/>

## 🏁라이선스
- 이 프로젝트는 MIT 라이선스 하에 공개됩니다. LICENSE 파일을 참조하십시오.

## ☎️연락처
<table>
  <tbody>
    <tr>
      <td align="center"><a href="https://github.com/JerryG0228"><img src="https://avatars.githubusercontent.com/u/75930663?v=4" width="100px;" alt=""/><br /><sub><b>Juhwan Cho</b></sub></a></td>
    </tr>
  </tobdy>
</table>

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[license-shield]: https://img.shields.io/github/license/JerryG0228/Zoovie.svg?style=flat
[license-url]: https://github.com/JerryG0228/Zoovie/blob/master/LICENSE.txt

[Flask]: https://img.shields.io/badge/Flask-black?style=for-the-badge&logo=Flask
[Flask-url]: https://fastapi.tiangolo.com/ko/

[MongoDB]: https://img.shields.io/badge/MongoDB-green?style=for-the-badge&logo=MongoDB
[MongoDB-url]: https://www.mongodb.com/ko-kr

[Flutter]: https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=Flutter
[Flutter-url]: https://flutter.dev/
