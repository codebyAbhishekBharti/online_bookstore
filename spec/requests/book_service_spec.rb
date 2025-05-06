require 'rails_helper'

RSpec.describe BookService do
  let(:vendor) { create(:user, role: 'vendor') }
  let!(:book) do
    create(:book, title: 'Book One', author: 'Author A', category_name: 'Fiction', vendor_id: vendor.id)
  end

  describe '.get_all_books' do
    it 'returns all books' do
      books = BookService.get_all_books
      expect(books).to include(book)
    end
  end

  describe '.insert_new_book' do
    it 'creates a new book with valid parameters' do
      params = {
        title: 'New Book',
        author: 'New Author',
        price: '19.99',
        description: 'A great read',
        stock_quantity: '10',
        category_name: 'Sci-Fi'
      }

      new_book = BookService.insert_new_book(vendor.id, params)
      expect(new_book).to be_persisted
      expect(new_book.title).to eq('New Book')
    end

    it 'raises error for duplicate book by same vendor' do
      params = {
        title: 'Book One',
        author: 'Another',
        price: '10.00',
        description: 'Test desc',
        stock_quantity: '5',
        category_name: 'Fiction'
      }
      expect {
        BookService.insert_new_book(vendor.id, params)
      }.to raise_error(BookErrors::BookAlreadyExistsError)
    end
  end

  describe '.get_book_by_id' do
    it 'returns the correct book' do
      found = BookService.get_book_by_id(book.id)
      expect(found).to eq(book)
    end

    it 'raises error if book not found' do
      expect {
        BookService.get_book_by_id(0)
      }.to raise_error(BookErrors::BookNotAvailableError)
    end
  end

  describe '.update_book_details' do
    it 'updates book fields' do
      params = { id: book.id, title: 'Updated Title' }
      updated = BookService.update_book_details(vendor.id, params)
      expect(updated.title).to eq('Updated Title')
    end

    it 'raises access denied if not the vendor' do
      other_user = create(:user)
      params = { id: book.id, title: 'Hack' }
      expect {
        BookService.update_book_details(other_user.id, params)
      }.to raise_error(BookErrors::AccessDeniedError)
    end
  end

  describe '.delete_book' do
    it 'deletes the book if vendor' do
      expect {
        BookService.delete_book(vendor.id, { id: book.id })
      }.to change { Book.count }.by(-1)
    end

    it 'raises error if not authorized' do
      other_user = create(:user)
      expect {
        BookService.delete_book(other_user.id, { id: book.id })
      }.to raise_error(BookErrors::AccessDeniedError)
    end
  end

  describe '.search_books' do
    it 'returns books based on title' do
      results = BookService.search_books(title: 'Book')
      expect(results.map(&:id)).to include(book.id)
    end

    it 'returns empty for unmatched search' do
      results = BookService.search_books(title: 'Nonexistent')
      expect(results).to be_empty
    end
  end
end
