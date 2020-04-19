<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

/**
 * @property integer $id
 * @property string $iso_code
 * @property string $name
 * @property string $deleted_at
 * @property string $created_at
 * @property string $updated_at
 */
class Countries extends Model
{
    /**
     * The "type" of the auto-incrementing ID.
     * 
     * @var string
     */
    protected $keyType = 'integer';

    /**
     * @var array
     */
    protected $fillable = ['iso_code', 'name', 'deleted_at', 'created_at', 'updated_at'];

}
