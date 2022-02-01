class BookRepresenter
    def initialize(book)
      @book = book
    end
    def as_json 
        id, title, author = @book.values_at(:id, :title, :author)
        {
            id: id,
            title: title,
            author_name: author_name(author),
            author_age: author.age
        }
    end

    private
    attr_reader :books
    
    def author_name(author)
        "#{author.first_name} #{author.last_name}"
    end
end