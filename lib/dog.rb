class Dog
    attr_accessor :id,:name,:breed
    def initialize(name:,breed:,id:nil)
        @id=id
        @name=name
        @breed=breed
    end
    def self.create_table
        sql= <<-SQL
        CREATE TABLE IF NOT EXISTS dogs(
            id INTEGER PRIMARY KEY,
            name TEXT,
            breed TEXT
        )
        SQL
        DB[:conn].execute(sql)
        self
    end
    def self.drop_table
        sql= <<-SQL
        DROP TABLE dogs
        SQL
        DB[:conn].execute(sql)
        self
    end
    def save
        sql = <<-SQL
        INSERT INTO dogs (name, breed)
        VALUES (?, ?)
      SQL
      DB[:conn].execute(sql, self.name, self.breed)
      self.id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
      self
    end
    def self.create(name:,breed:)
        dog= Dog.new(name: name, breed: breed)
        dog.save
    end
    def self.new_from_db(dog)
        self.new(id:dog[0], name:dog[1], breed:dog[2])
    end
    def self.all
        sql = <<-SQL
        SELECT * FROM dogs
        SQL

        DB[:conn].execute(sql).map do |dog|
        self.new_from_db(dog)
        end
    end
    def self.find_by_name(name)
        sql = <<-SQL
        SELECT * FROM dogs 
        WHERE dogs.name = ?
        LIMIT 1
        SQL

        newarr= DB[:conn].execute(sql, name).map do |dog|
            self.new_from_db(dog)
        end
        newarr.first
    end
    def self.find(id)
        sql = <<-SQL
        SELECT * FROM dogs 
        WHERE dogs.id = ?
        LIMIT 1
        SQL

        newarr= DB[:conn].execute(sql, id).map do |dog|
            self.new_from_db(dog)
        end
        newarr.first
    end
end
