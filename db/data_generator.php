<?php
$names = ['Juan dela Cruz', 'Maria Clara Santos', 'Jose Rizal', 'Andres Bonifacio', 'Gabriela Silang', 'Lapu-Lapu', 'Emilio Aguinaldo', 'Ana Reyes', 'Pedro Garcia', 'Luzviminda Torres', 'Roberto Lim', 'Carmencita Mendoza', 'Eduardo Fernandez', 'Rosita Aquino', 'Antonio Bautista', 'Elena Castro', 'Felipe Gozon', 'Sofia Vergara', 'Marco Antonio', 'Isabella Cruz'];
$firstNames = ['Maria', 'Jose', 'Antonio', 'Juan', 'Pedro', 'Ana', 'Carmen', 'Rosa', 'Elena', 'Carlos', 'Roberto', 'Luz', 'Sofia', 'Isabella', 'Gabriel', 'Miguel', 'Angel', 'Cristina', 'Fernando', 'Ricardo'];
$lastNames = ['Santos', 'Cruz', 'Garcia', 'Reyes', 'Torres', 'Lopez', 'Villanueva', 'Ramos', 'Mendoza', 'Fernandez', 'Bautista', 'Castro', 'Lim', 'Aquino', 'Gozon', 'Vergara', 'Antonio', 'Silang', 'Bonifacio', 'Aguinaldo'];
$relationships = ['Spouse', 'Son', 'Daughter', 'Brother', 'Sister', 'Father', 'Mother', 'Grandfather', 'Grandmother', 'Uncle', 'Aunt', 'Cousin', 'Nephew', 'Niece'];
$genders = ['Male', 'Female'];
$educationStatuses = ['Undergraduate', 'Graduate', 'High School', 'Elementary', 'Not in School'];
$yearLevels = ['1st Year', '2nd Year', '3rd Year', '4th Year'];
$courses = ['BS Computer Science', 'BS Education', 'BS Nursing', 'BS Engineering', 'BS Business Administration', 'BS Agriculture'];
$employmentStatuses = ['Employed', 'Unemployed'];
$occupations = ['Teacher', 'Nurse', 'Engineer', 'Farmer', 'Business Owner', 'Government Employee', 'Private Employee', 'Self-employed', 'Driver', 'Vendor'];
$employers = ['Public School', 'Private Hospital', 'Construction Company', 'Local Government', 'Private Company', 'Self-employed', 'N/A'];
$streets = ['Purok 1', 'Purok 2', 'Purok 3', 'Purok Sampaguita', 'Sitio Ilang-ilang', 'Purok Lanzones', 'Purok Rosal', 'Purok Mango', 'Sitio Baybay', 'Purok Kamunggay'];

echo "INSERT INTO households (household_number, head_of_household, contact_number, street, barangay, city, province, family_members, economic_data, created_at, updated_at, census_year) VALUES\n";

function generateFamilyMembers($headName, $count)
{
    global $firstNames, $lastNames, $relationships, $genders, $educationStatuses, $yearLevels, $courses, $employmentStatuses;

    $members = [];
    $headLastName = explode(' ', $headName);
    $headLastName = end($headLastName);

    for ($i = 0; $i < $count; $i++) {
        $name = $firstNames[array_rand($firstNames)] . ' ' . $headLastName;
        $age = rand(5, 65);
        $gender = $genders[array_rand($genders)];
        $relationship = $relationships[array_rand($relationships)];

        $member = [
            'name' => $name,
            'age' => $age,
            'gender' => $gender,
            'relationship' => $relationship,
            'philsys_image' => null
        ];

        // Add education/employment data for adults (18+)
        if ($age >= 18) {
            $educationStatus = $educationStatuses[array_rand($educationStatuses)];
            $member['education_status'] = $educationStatus;

            if ($educationStatus == 'Undergraduate') {
                $member['year_level'] = $yearLevels[array_rand($yearLevels)];
                $member['course'] = $courses[array_rand($courses)];
                $member['employment_status'] = null;
            } else if ($educationStatus == 'Graduate') {
                $member['year_level'] = null;
                $member['course'] = null;
                $member['employment_status'] = $employmentStatuses[array_rand($employmentStatuses)];
            } else {
                $member['year_level'] = null;
                $member['course'] = null;
                $member['employment_status'] = null;
            }
        } else {
            $member['education_status'] = null;
            $member['year_level'] = null;
            $member['course'] = null;
            $member['employment_status'] = null;
        }

        $members[] = $member;
    }

    return json_encode($members, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
}

function generateEconomicData($headName, $familyMembersJson)
{
    global $occupations, $employers;

    $economicData = [];
    $members = json_decode($familyMembersJson, true);

    // Generate economic data for employed adults
    foreach ($members as $member) {
        if (isset($member['employment_status']) && $member['employment_status'] == 'Employed' && $member['age'] >= 18) {
            $occupation = $occupations[array_rand($occupations)];
            $employer = $employers[array_rand($employers)];
            $income = rand(10000, 50000); // Monthly income in PHP

            $economicData[] = [
                'member_name' => $member['name'],
                'occupation' => $occupation,
                'monthly_income' => $income,
                'employer' => $employer
            ];
        }
    }

    // Always include head of household if no economic data
    if (empty($economicData)) {
        $occupation = $occupations[array_rand($occupations)];
        $employer = $employers[array_rand($employers)];
        $income = rand(15000, 40000);

        $economicData[] = [
            'member_name' => $headName,
            'occupation' => $occupation,
            'monthly_income' => $income,
            'employer' => $employer
        ];
    }

    return json_encode($economicData, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
}

for ($year = 2016; $year <= 2025; $year++) {
    for ($i = 1; $i <= 35; $i++) {
        $hhnum = sprintf("HH-%d-%03d", $year, $i);
        $head = $names[array_rand($names)];
        $familyCount = rand(2, 8); // Number of family members (excluding head)
        $contact = '09' . rand(1, 9) . rand(10000000, 99999999);
        $street = $streets[array_rand($streets)];
        $date = sprintf("%d-%02d-%02d %02d:%02d:%02d", $year, rand(1, 12), rand(1, 28), rand(8, 18), rand(0, 59), rand(0, 59));

        // Generate family members JSON
        $familyMembers = generateFamilyMembers($head, $familyCount);

        // Generate economic data JSON
        $economicData = generateEconomicData($head, $familyMembers);

        // Escape single quotes in JSON strings for SQL
        $familyMembersEscaped = str_replace("'", "''", $familyMembers);
        $economicDataEscaped = str_replace("'", "''", $economicData);

        echo "('$hhnum','$head','$contact','$street','Rizal','Katipunan','Zamboanga del Norte','$familyMembersEscaped','$economicDataEscaped','$date','$date',$year)";
        echo ($year == 2025 && $i == 35) ? ";\n" : ",\n";
    }
}
?>