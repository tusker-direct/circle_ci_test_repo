package MyApp::Database;
use strict;
use warnings;
use DBI;

sub new {
    my ($class) = @_;
    
	warn "DB_NAME: $ENV{DB_NAME}";
	warn "DB_HOST: $ENV{DB_HOST}";
	warn "DB_PORT: $ENV{DB_PORT}";
	warn "DB_USER: $ENV{DB_USER}";
	warn "DB_PASSWORD: $ENV{DB_PASSWORD}";
    my $self = {
        dbh => DBI->connect(
            "dbi:Pg:dbname=$ENV{DB_NAME};host=$ENV{DB_HOST};port=$ENV{DB_PORT}",
            $ENV{DB_USER},
            $ENV{DB_PASSWORD},
            {
                RaiseError => 1,
                AutoCommit => 1,
                pg_enable_utf8 => 1,
            }
        )
    };
    
    bless $self, $class;
    $self->_init_db();
    return $self;
}

sub _init_db {
    my $self = shift;
    
    # Create users table
    $self->{dbh}->do(q{
        CREATE TABLE IF NOT EXISTS users (
            id SERIAL PRIMARY KEY,
            username VARCHAR(50) UNIQUE NOT NULL,
            email VARCHAR(255) UNIQUE NOT NULL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
    });

    # Create cars table
    $self->{dbh}->do(q{
        CREATE TABLE IF NOT EXISTS cars (
            id SERIAL PRIMARY KEY,
            make VARCHAR(50) NOT NULL,
            model VARCHAR(50) NOT NULL,
            year INTEGER NOT NULL,
            price DECIMAL(10,2) NOT NULL,
            user_id INTEGER REFERENCES users(id),
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
    });

    # Add sample data if tables are empty
    my $count = $self->{dbh}->selectrow_array("SELECT COUNT(*) FROM cars");
    if ($count == 0) {
        # First add some users if none exist
        my $user_count = $self->{dbh}->selectrow_array("SELECT COUNT(*) FROM users");
        if ($user_count == 0) {
            $self->add_user('john_doe', 'john@example.com');
            $self->add_user('jane_smith', 'jane@example.com');
            $self->add_user('bob_wilson', 'bob@example.com');
        }

        my @sample_cars = (
            ['Toyota', 'Camry', 2020, 25000.00, 1],
            ['Honda', 'Civic', 2021, 22000.00, 1],
            ['Tesla', 'Model 3', 2022, 45000.00, 2],
            ['Ford', 'Mustang', 2019, 35000.00, 2],
            ['BMW', 'X5', 2021, 62000.00, 3]
        );

        my $sth = $self->{dbh}->prepare(
            "INSERT INTO cars (make, model, year, price, user_id) VALUES (?, ?, ?, ?, ?)"
        );
        
        for my $car (@sample_cars) {
            $sth->execute(@$car);
        }
    }
}

sub all_cars {
    my $self = shift;
    my $sth = $self->{dbh}->prepare("SELECT * FROM cars");
    $sth->execute();
    return $sth->fetchall_arrayref({});
}

sub add_user {
    my ($self, $username, $email) = @_;
    my $sth = $self->{dbh}->prepare(
        "INSERT INTO users (username, email) VALUES (?, ?)"
    );
    $sth->execute($username, $email);
    return $self->{dbh}->last_insert_id(undef, undef, "users", undef);
}

sub get_user {
    my ($self, $id) = @_;
    my $sth = $self->{dbh}->prepare("SELECT * FROM users WHERE id = ?");
    $sth->execute($id);
    return $sth->fetchrow_hashref;
}

sub add_car {
    my ($self, $make, $model, $year, $price, $user_id) = @_;
    my $sth = $self->{dbh}->prepare(
        "INSERT INTO cars (make, model, year, price, user_id) VALUES (?, ?, ?, ?, ?)"
    );
    $sth->execute($make, $model, $year, $price, $user_id);
    return $self->{dbh}->last_insert_id(undef, undef, "cars", undef);
}

sub get_car {
    my ($self, $id) = @_;
    my $sth = $self->{dbh}->prepare("SELECT * FROM cars WHERE id = ?");
    $sth->execute($id);
    return $sth->fetchrow_hashref;
}

sub get_user_cars {
    my ($self, $user_id) = @_;
    my $sth = $self->{dbh}->prepare("SELECT * FROM cars WHERE user_id = ?");
    $sth->execute($user_id);
    return $sth->fetchall_arrayref({});
}

1; 