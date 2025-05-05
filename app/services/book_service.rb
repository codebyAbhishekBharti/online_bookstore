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
    raise BookErrors::InvalidParametersError, "Title, author, price, description, stock quantity and category name are required" if title.blank? || author.blank? || price.blank? || description.blank? || stock_quantity.blank? || category_name.blank?

    existing_book = Book.find_by(title: title, vendor_id: user_id)
    raise BookErrors::BookAlreadyExistsError, "Book with this title already exists for this vendor" if existing_book

    book = Book.create!(
      title: title,
      author: author,
      price: price,
      description: description,
      stock_quantity: stock_quantity,
      category_name: category_name,
      vendor_id: user_id
    )

    # invalidating redis search cache
    invalidate_search_cache(book)

    book
  end

  def self.get_book_by_id(id)
    book = Book.find_by(id: id)
    raise BookErrors::BookNotAvailableError, "Book not found" unless book
    book
  end

  def self.update_book_details(user_id, params)
    book = self.get_book_by_id(params[:id])

    # check if user is vendor of that book
    if book.vendor_id != user_id
      raise BookErrors::AccessDeniedError, "User is not authorized to update this book"
    end
    # Updating book details
    allowed_params = [ :title, :author, :price, :description, :stock_quantity, :category_name ]
    filtered_params = params.slice(*allowed_params)
    book.update!(filtered_params)
    raise BookErrors::RecordNotFound, "Book not found" if book.blank?
    book  # Return updated book object
  end

  def self.delete_book(user_id, params)
    # Find the book by ID
    puts user_id
    book = self.get_book_by_id(params[:id])

    # Check if the user is the vendor of the book
    unless book.vendor_id == user_id
      raise BookErrors::AccessDeniedError, "User is not authorized to delete this book"
    end

    # Remove the book's cache from Redis
    cache_key = "book_#{book.id}"
    Rails.cache.delete(cache_key)

    # Invalidate search cache that may have included this book
    invalidate_search_cache(book)

    # Attempt to destroy the book
    book.destroy!
  end

  def self.search_books(params)
    title    = params[:title].to_s.downcase.strip
    author   = params[:author].to_s.downcase.strip
    category = params[:category].to_s.downcase.strip

    # Generate a unique cache key based on search parameters
    cache_key = search_cache_key(title: title, author: author, category: category)

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
    search_params = [
      { title: book.title, author: book.author, category: book.category_name },
      { title: book.title, author: book.author },
      { title: book.title, category: book.category_name },
      { author: book.author, category: book.category_name },
      { title: book.title },
      { author: book.author },
      { category: book.category_name }
    ]

    search_params.each do |params|
      cache_key = search_cache_key(title: params[:title], author: params[:author], category: params[:category])
      Rails.cache.delete(cache_key)
    end
  end


  def self.search_cache_key(title: "", author: "", category: "")
    normalized = [
      title.to_s.downcase.strip,
      author.to_s.downcase.strip,
      category.to_s.downcase.strip
    ]
    "search_books_#{Digest::MD5.hexdigest(normalized.join('_'))}"
  end
end
