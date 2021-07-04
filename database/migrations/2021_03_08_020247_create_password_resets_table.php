<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreatePasswordResetsTable extends Migration {

	/**
	 * Run the migrations.
	 *
	 * @return void
	 */
	public function up()
	{
		Schema::create('password_resets', function(Blueprint $table)
		{
			$table->engine = 'InnoDB';
			$table->integer('id', true);
			$table->string('email')->index('email');
			$table->string('token')->index('token');
			$table->timestamps(6);
		});
	}


	/**
	 * Reverse the migrations.
	 *
	 * @return void
	 */
	public function down()
	{
		Schema::drop('password_resets');
	}

}