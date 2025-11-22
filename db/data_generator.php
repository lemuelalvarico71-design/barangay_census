<?php
$names = ['Juan dela Cruz','Maria Clara Santos','Jose Rizal','Andres Bonifacio','Gabriela Silang','Lapu-Lapu','Emilio Aguinaldo','Ana Reyes','Pedro Garcia','Luzviminda Torres','Roberto Lim','Carmencita Mendoza','Eduardo Fernandez','Rosita Aquino','Antonio Bautista','Elena Castro','Felipe Gozon','Sofia Vergara','Marco Antonio','Isabella Cruz'];
$barangays = ['Poblacion','Uno','Dos','Santo Niño','Malobago','Miatan','Singaran','Loyuran','Dr. Jose Rizal','San Antonio','Sikitan','Tiniguangan','Nabago','Carupay'];
$streets = ['Purok 1','Purok 2','Purok 3','Purok Sampaguita','Sitio Ilang-ilang','Purok Lanzones','Purok Rosal','Purok Mango','Sitio Baybay','Purok Kamunggay'];

echo "INSERT INTO households (household_number, head_of_household, total_members, contact_number, street, barangay, city, province, zip_code, gps_verified, created_at, updated_at, census_year) VALUES\n";

for ($year = 2016; $year <= 2025; $year++) {
    for ($i = 1; $i <= 35; $i++) {
        $hhnum = sprintf("HH-%d-%03d", $year, $i);
        $head = $names[array_rand($names)];
        $members = rand(3,15);
        $contact = '09'.rand(1,9).rand(10000000,99999999);
        $street = $streets[array_rand($streets)];
        $brgy = $barangays[array_rand($barangays)];
        $date = sprintf("%d-%02d-%02d %02d:%02d:%02d", $year, rand(1,12), rand(1,28), rand(8,18), rand(0,59), rand(0,59));

        echo "('$hhnum','$head',$members,'$contact','$street','$brgy','Katipunan','Zamboanga del Norte','7109',0,'$date','$date',$year)";
        echo ($year==2025 && $i==35) ? ";\n" : ",\n";
    }
}
?>