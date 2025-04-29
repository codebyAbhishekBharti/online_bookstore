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
    allowed_params = [:title, :author, :price, :description, :stock_quantity, :category_name]
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
    # Finding the book by ID
    book = self.get_book_by_id(params[:id])
    # Check if the book exists
    raise "Book not found" unless book
    # check if user is vendor of that book
    if book.vendor_id != user_id
      raise "User is not authorized to delete this book"
    end
    # Deleting the book record
    book.destroy!
  rescue ActiveRecord::RecordNotFound => e
    raise "Book not found: #{e.message}"
  rescue ActiveRecord::RecordInvalid => e
    raise "Failed to delete book: #{e.message}"
  rescue StandardError => e
    raise "An error occurred: #{e.message}"
  end
end