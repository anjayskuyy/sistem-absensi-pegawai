<?php

namespace App\Models;

use App\Models\Attende;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class AttendeStatus extends Model
{
    use HasFactory;

    protected $guarded = [];

    public function kehadiran()
    {
        return $this->hasMany(Attende::class, 'attende_status_id', 'id');
    }
}
