<h1 align="center">Inventory Management System</h1>
<hr>

## Quick Installation

    cd Inventory_Management_System

### Composer

    composer update

### Environment

    cp .env.example .env

### Database Migration

Create a database named `IMS` and update the database credentials in `.env`, then run:

    php artisan migrate

### Start the server

    php artisan serve
