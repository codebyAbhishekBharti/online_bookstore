# app/services/v1/book_service.rb
class BookService
  def self.hello
    "version 1 book service kaam kar raha hai"
  end
  def self.get_all_books
    # Fetching all books from the database
    Book.all
  end
  def self.insert_new_book(user_id, params)
    # Extracting parameters
    title = params[:title]
    author = params[:author]
    price = params[:price]
    description = params[:description]
    stock_quantity = params[:stock_quantity]
    category_name = params[:category_name]
    # Creating a new book record
    book = Book.create!(
      title: title,
      author: author,
      price: price,
      description: description,
      stock_quantity: stock_quantity,
      category_name: category_name,
      vendor_id: user_id
    )
    book
  end

  def self.get_book_by_id(id)
    # Finding the book by ID
    book = Book.find_by(id: id)
    # Check if the book exists
    raise "Book not found" unless book
    book  # Return the book object
  rescue ActiveRecord::RecordNotFound => e
    raise "Book not found: #{e.message}"
  rescue StandardError => e
    raise "An error occurred: #{e.message}"
  end

  def self.update_book_details(user_id, params)
    # Finding the book by ID
    book = self.get_book_by_id(params[:id])
    # Check if the book exists
    raise "Book not found" unless book
    # check if user is vendor of that book
    if book.vendor_id != user_id
      raise "User is not authorized to update this book"
    end
    # Updating book details
    allowed_params = [ :title, :author, :price, :description, :stock_quantity, :category_name ]
    filtered_params = params.slice(*allowed_params)
    book.update!(filtered_params)
    book  # Return updated book object
  rescue ActiveRecord::RecordNotFound => e
    raise "Book not found: #{e.message}"
  rescue ActiveRecord::RecordInvalid => e
    raise "Failed to update book: #{e.message}"
  rescue StandardError => e
    raise "An error occurred: #{e.message}"
  end

  def self.delete_book(user_id, params)
    # Find the book by ID
    puts user_id
    book = self.get_book_by_id(params[:id])
  
    # Check if the book exists
    raise ActiveRecord::RecordNotFound, "Book not found" unless book
  
    # Check if the user is the vendor of the book
    unless book.vendor_id == user_id
      raise StandardError, "User is not authorized to delete this book"
    end

    # Remove the book's cache from Redis
    cache_key = "book_#{book.id}"
    Rails.cache.delete(cache_key)

    # Invalidate search cache that may have included this book
    invalidate_search_cache(book)

    # Attempt to destroy the book
    book.destroy!
  end
  

  def self.search_books_by_title(title)
    # Searching for books by title
    books = Book.where("title LIKE ?", "%#{title}%")
    if books.empty?
      raise "No books found with the title: #{title}"
    end
    books  # Return the list of books
  rescue StandardError => e
    raise "An error occurred: #{e.message}"
  end

  def self.search_books_by_author(author)
    # Searching for books by author
    books = Book.where("author LIKE ?", "%#{author}%")
    if books.empty?
      raise "No books found by the author: #{author}"
    end
    books  # Return the list of books
  rescue StandardError => e
    raise "An error occurred: #{e.message}"
  end

  def self.search_books_by_title_and_author(title, author)
    # Searching for books by title and author
    books = Book.where("title LIKE ? AND author LIKE ?", "%#{title}%", "%#{author}%")
    if books.empty?
      raise "No books found with the title: #{title} and author: #{author}"
    end
    books  # Return the list of books
  rescue StandardError => e
    raise "An error occurred: #{e.message}"
  end

  def self.search_books_by_category(category_name)
    # Searching for books by category name
    books = Book.where("category_name LIKE ?", "%#{category_name}%")
    if books.empty?
      raise "No books found in the category: #{category_name}"
    end
    books  # Return the list of books
  rescue StandardError => e
    raise "An error occurred: #{e.message}"
  end

  def self.search_books(params)
    title    = params[:title].to_s.downcase.strip
    author   = params[:author].to_s.downcase.strip
    category = params[:category].to_s.downcase.strip
  
    # Generate a unique cache key based on search parameters
    cache_key = "search_books_#{Digest::MD5.hexdigest("#{title}_#{author}_#{category}")}"
  
    Rails.cache.fetch(cache_key, expires_in: 30.minutes) do
      books = Book.all
      books = books.where("title ILIKE ?", "%#{title}%") if title.present?
      books = books.where("author ILIKE ?", "%#{author}%") if author.present?
      books = books.where("category_name ILIKE ?", "%#{category}%") if category.present?
      
      books.to_a
    end
  end

  private

  # This method invalidates the search cache related to the book.
  def self.invalidate_search_cache(book)
    # Let's get the search parameters for the book
    search_params = [
      { title: book.title, author: book.author, category: book.category_name },
      { title: book.title, author: book.author },
      { title: book.title, category: book.category_name },
      { author: book.author, category: book.category_name },
      { title: book.title },
      { author: book.author },
      { category: book.category_name }
    ]

    # For each combination of search parameters, generate the cache key and delete it
    search_params.each do |params|
      cache_key = "search_books_#{Digest::MD5.hexdigest(params.to_s)}"
      Rails.cache.delete(cache_key)
    end
  end
end
