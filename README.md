Instruksi Pengunaan Aplikasi Lokamotive 

1. Clone Repository Github dari aplikasi lokamotive melalui link berikut https://github.com/Fritz1212/Lokamotive.git
2. Buka Folder pada vscode kemudian buka file main.dart
3. Pastikan Device HP dan Komputer atau laptop terdapat pada jaringan yang sama 
4. Buka File .env dan isi bagian IP_ADDRESS dengan ip dari jaringan yang sedang digunakan
5. Download XAMPP untuk mengimport databasenya
6. Pada XAMPP nyalakan Apache dan MySQL
7. Import File sql yang sudah diberikan (lokamotive.sql) dengan memberi nama lokamotive
8. Berikan akses koneksi database dengan membuat profile dengan pada aplikasi XAMPP, buka bagian tab user account kemudian klik login information 
9. Isi seperti ini :
Username : lokamotiveBINUS
Hostname : localhost (jangan tinggalin cuma pake %)
Password : lokamotive123
10. Pada bagian global previlige, checklist "check all" dan tekan tombol go pada pojok kiri bawah 
11. Jika terjadi "Aria engine error", masuk ke database "mysql" kemudian check semua database dan lakukan repair table 
12. Download node.js dan NPM melalui browser
13. Change directory terminal ke /lib
14. ketik npm install
15. lakukan command "node server.js"
16. ketik "flutter pub get" untuk mendapatkan dependenct
17. Run project ini dengan menekan F5 ataupun mengetik "flutter run" pada terminal
18. Lakukan Register
19. Aplikasi Siap Digunakan