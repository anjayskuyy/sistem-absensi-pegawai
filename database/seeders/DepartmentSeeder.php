<?php

namespace Database\Seeders;

use App\Models\Department;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use JeroenZwart\CsvSeeder\CsvSeeder;

class DepartmentSeeder extends CsvSeeder
{

    public function __construct()
    {
        $this->file = '/database/csv/departments.csv';
        $this->defaults = [
            'created_at' => now(),
            'updated_at' => now()
        ];
    }

    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        DB::statement('SET FOREIGN_KEY_CHECKS = 0');
        DB::disableQueryLog();
        parent::run();
        DB::statement('SET FOREIGN_KEY_CHECKS = 1');
    }
}
