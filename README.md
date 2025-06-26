I.    from Android Studio; Setup a new virtual device emulator

	1. Open Android Studio 
	2. Virtual Device Manager 
	3. Create virtual device 
	4. choose category tablet 
	5. choose Pixel Tablet, size 10.95"
	6. System Image: select release VanillaIceCream API Level 35, Target Android 15.0 (Google Play) 
	7. check the startup orientation: Landscape
 	8. finish


II.    from Visual Studio Code; run project

***make sure to install following Extensions in VS Code: Flutter, Dart
	
	1. install the salon_pos.zip
	2. place the salon_pos folder to any path, then open with Visual Studio Code
		***upon opening project, there are errors (all from "imports") as you are yet to install all the required dependencies. just click on the hint bulb and select option "Add XX dependencies to the flutter" on every errors
	3. on the bar below (likely left side of notification bell icon) select a device to use: Start Pixel Tablet API 35 mobile emulator
	4. from vs code, open file main.dart through path salon_pos/lib/main.dart
	5. start debugging the file main.dart
	6. debugging would takes time, and will be reflected on your Pixel Tablet Emulator
	

III.    from Pixel Tablet Emulator; simulate project

	1. in login page, enter the system using admin credentials (user: admin, pass: admin123)
	2. through dashboard, add new item and staff
		***follow step iv. if you would like to test on our data samples
	3. logout, then login as staff (can login by username or id)
	

---Below are optional, if you would like to add all data samples into the db---

.

.

.

IV.    from Android Studio; adding datas into database

***find the sql file salon_db.sql in the zipped folder salon_pos, open and copy all the sql operations (or just copy INSERT INTO ... VALUES operations as tables are already created through debugging main.dart)
		
	1. open Android Studio
	2. open the project path salon_pos (anywhere you placed earlier)
	3. in the left sidebar, open tools App Inspection
	4. click on "No Process Selected", and select Pixel Tablet API 35 > com.example.salon_pos
	5. database would likely be closed upon new opening, from Pixel Tablet Emulator; add at least one new staff
	6. database connection are now open, make sure to delete the newly added staff to avoid data clashing during sql injection
	7. in toolbar in the Database Inspector, select Open New Query Tab
	8. in New Query tab, paste all the sql operations you copied from salon_db.sql
	9. click on "Run"
	10. sql query should be successful, all data are now in the database and reflected on Pixel Tablet Emulator
	


Goodluck, do contact us if there are any problem regarding the installation
izzat-kz    IZZAT KZ (Project Leader, Main Developer)
hilman45    HILMAN (Designer, Project Architect)
kinznafy71  HANAFI (Second Developer)
