# Pokémon Team Builder App

แอปนี้พัฒนาโดยใช้ **Flutter + GetX + GetStorage**  
ให้ผู้ใช้สามารถเลือก **ทีม Pokémon ได้สูงสุด 3 ตัว** จากรายชื่อ Pokémon อย่างน้อย 20 ตัว  
และสามารถแก้ไขชื่อทีมได้ ข้อมูลจะถูกบันทึกด้วย **GetStorage** (เปิดปิดแอปแล้วข้อมูลยังอยู่)  

## Features

- เลือก Pokémon ทีมได้สูงสุด 3 ตัว
- แก้ไขชื่อทีม
- Reset ทีม
- ข้อมูลทีมและชื่อทีมจะถูกบันทึกลง **Local storage (GetStorage)**
- (Optional) Fetch ข้อมูล Pokémon จาก **PokeAPI**
- (Optional) Search bar สำหรับค้นหา Pokémon
- (Optional) Visual feedback/animations เมื่อเลือกหรือยกเลิก Pokémon

## Dependencies

dependencies:
  flutter:
    sdk: flutter
  get: ^4.6.6
  get_storage: ^2.1.1
  http: ^1.2.2  

## Installation

1. ติดตั้ง Flutter SDK  
   ลิงก์: https://flutter.dev/

2. ติดตั้ง Android Studio  
   ลิงก์: https://developer.android.com/studio?hl=th

3. ทำการสร้าง/เชื่อมต่ออุปกรณ์จำลอง (Emulator) ผ่าน Android Studio

4. ทำการ Clone ตัวโปรเจกต์นี้  
   ```bash
   git clone https://github.com/BomNattawut/pokemonteambuilder.git
5. เข้าไปที่ตัวโปรเจกต์และติดตั้ง dependencies ที่จำเป็นสำหรับแอพ
  cd pokemonteambuilder
  flutter pub get
6.ใช้คำสั่งเพื่อรันแอพ  flutter run


 


