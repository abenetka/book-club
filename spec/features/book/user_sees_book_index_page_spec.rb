require 'rails_helper'

describe 'As a Visitor' do
  describe 'when I visit a book index page' do
    it 'displays all book titles' do
      book_1 = Book.create(title: "Fire and Ice", pages: 400, publication_year: 2016)
      book_2 = Book.create(title: "Ooo Dragons", pages: 500, publication_year: 2017)
      book_3 = Book.create(title: "Oh no, ice zombies", pages: 600, publication_year: 2018)

      visit books_path

      expect(page).to have_content("All Books")
      expect(page).to have_content(book_1.title)
      expect(page).to have_content("Pages: #{book_1.pages}")
      expect(page).to have_content("Publication: #{book_1.publication_year}")
      expect(page).to have_content(book_2.title)
      expect(page).to have_content("Pages: #{book_2.pages}")
      expect(page).to have_content("Publication: #{book_2.publication_year}")
      expect(page).to have_content(book_3.title)
      expect(page).to have_content("Pages: #{book_3.pages}")
      expect(page).to have_content("Publication: #{book_3.publication_year}")
    end

    it 'shows book titles as links to the book show page' do
      book_1 = Book.create(title: "Oh no, ice zombies", pages: 600, publication_year: 2018)

      visit books_path

      click_link book_1.title

      expect(current_path).to eq(book_path(book_1))
      expect(page).to have_content(book_1.title)
    end

    it 'shows authors as links to the authors show page' do
      book_1 = Book.create(title: "Oh no, ice zombies", pages: 600, publication_year: 2018)
      book_2 = Book.create(title: "Dragon Zombies", pages: 500, publication_year: 2019)
      author_1 = Author.create(name: "George Martin", books: [book_1])
      author_2 = Author.create(name: "George Lucus", books: [book_1, book_2])

      visit books_path

      click_link author_1.name

      expect(current_path).to eq(author_path(author_1))
      expect(page).to have_content(author_1.name)
    end

    it 'shows average rating for each book' do
      book_1 = Book.create(title: "Oh no, ice zombies", pages: 600, publication_year: 2018)
      user_1 = User.create(name: "Hamburglar")
      user_2 = User.create(name: "Michael")
      user_3 = User.create(name: "Ricardo")
      user_4 = User.create(name: "Lance")
      review_1 = user_1.reviews.create(title: "Terrible book!", description: "Bitters retro mustache aesthetic biodiesel 8-bit.", rating: 1, book: book_1)
      review_2 = user_2.reviews.create(title: "Thrilling book", description: "Park iphone leggings put a bird on it.", rating: 5, book: book_1)
      review_3 = user_3.reviews.create(title: "Amazing book!", description: "I love this book so much. It's the best thing I've ever read!!!!!!.", rating: 2, book: book_1)
      review_4 = user_4.reviews.create(title: "It was a book?", description: "Eh, it was ok.", rating: 3, book: book_1)

      visit books_path

      expect(page).to have_content(book_1.average_rating)
    end

    it 'sorts books by page length' do
      book_1 = Book.create(title: "Oh no, ice zombies", pages: 600, publication_year: 2018)
      book_2 = Book.create(title: "Dragons and Zombies, oh my!", pages: 800, publication_year: 2018)
      book_3 = Book.create(title: "A Guide on How do Ice Skate with Dragons and Zombies", pages: 1000, publication_year: 2019)
      user_1 = User.create(name: "Hamburglar")
      user_2 = User.create(name: "Michael")
      user_3 = User.create(name: "Ricardo")
      user_4 = User.create(name: "Lance")
      review_1 = user_1.reviews.create(title: "Terrible book!", description: "Bitters retro mustache aesthetic biodiesel 8-bit.", rating: 1, book: book_1)
      review_2 = user_2.reviews.create(title: "Thrilling book", description: "Park iphone leggings put a bird on it.", rating: 5, book: book_1)
      review_3 = user_3.reviews.create(title: "Amazing book!", description: "I love this book so much. It's the best thing I've ever read!!!!!!.", rating: 2, book: book_1)
      review_4 = user_2.reviews.create(title: "It was a book?", description: "Eh, it was ok.", rating: 3, book: book_2)
      review_5 = user_3.reviews.create(title: "My Favorite Book", description: "SO GOOD, EVERYONE READ THIS BOOK!", rating: 4, book: book_2)
      review_6 = user_4.reviews.create(title: "I should probably read it again", description: "Didn't really follow what was going on.", rating: 5, book: book_2)
      review_7 = user_1.reviews.create(title: "Scary Book", description: "0 Stars, too scary.", rating: 1, book: book_3)

      visit books_path
      click_link "Most Number of Pages"
      within "article.book_container-0" do
        expect(page).to have_content(book_3.title)
      end

      visit books_path
      click_link "Least Number of Pages"
      within "article.book_container-0" do
        expect(page).to have_content(book_1.title)
      end
    end


    it 'sorts books by number of reviews' do
      book_1 = Book.create(title: "Oh no, ice zombies", pages: 600, publication_year: 2018)
      book_2 = Book.create(title: "Dragons and Zombies, oh my!", pages: 800, publication_year: 2018)
      book_3 = Book.create(title: "A Guide on How do Ice Skate with Dragons and Zombies", pages: 1000, publication_year: 2019)

      user_1 = User.create(name: "Hamburglar")
      user_2 = User.create(name: "Michael")
      user_3 = User.create(name: "Ricardo")
      user_4 = User.create(name: "Lance")
      review_1 = user_1.reviews.create(title: "Terrible book!", description: "Bitters retro mustache aesthetic biodiesel 8-bit.", rating: 1, book: book_1)
      review_2 = user_2.reviews.create(title: "Thrilling book", description: "Park iphone leggings put a bird on it.", rating: 5, book: book_1)
      review_3 = user_3.reviews.create(title: "Amazing book!", description: "I love this book so much. It's the best thing I've ever read!!!!!!.", rating: 2, book: book_1)
      review_4 = user_2.reviews.create(title: "It was a book?", description: "Eh, it was ok.", rating: 3, book: book_2)
      review_5 = user_3.reviews.create(title: "My Favorite Book", description: "SO GOOD, EVERYONE READ THIS BOOK!", rating: 4, book: book_2)
      review_6 = user_4.reviews.create(title: "I should probably read it again", description: "Didn't really follow what was going on.", rating: 5, book: book_2)
      review_7 = user_1.reviews.create(title: "Scary Book", description: "0 Stars, too scary.", rating: 1, book: book_3)
      review_8 = user_1.reviews.create(title: "Scary Book", description: "0 Stars, too scary.", rating: 1, book: book_1)

      visit books_path
      click_link "Most Reviews"
      within "article.book_container-0" do
        expect(page).to have_content(book_1.title)
      end

      visit books_path
      click_link "Least Reviews"
      within "article.book_container-0" do
        expect(page).to have_content(book_3.title)
      end
    end

    it 'sorts books by rating' do
      book_1 = Book.create(title: "Oh no, ice zombies", pages: 600, publication_year: 2018)
      book_2 = Book.create(title: "Dragons and Zombies, oh my!", pages: 800, publication_year: 2018)
      book_3 = Book.create(title: "A Guide on How do Ice Skate with Dragons and Zombies", pages: 1000, publication_year: 2019)

      user_1 = User.create(name: "Hamburglar")
      user_2 = User.create(name: "Michael")
      user_3 = User.create(name: "Ricardo")
      user_4 = User.create(name: "Lance")
      review_1 = user_1.reviews.create(title: "Terrible book!", description: "Bitters retro mustache aesthetic biodiesel 8-bit.", rating: 1, book: book_1)
      review_2 = user_2.reviews.create(title: "Thrilling book", description: "Park iphone leggings put a bird on it.", rating: 5, book: book_1)
      review_3 = user_3.reviews.create(title: "Amazing book!", description: "I love this book so much. It's the best thing I've ever read!!!!!!.", rating: 2, book: book_1)
      review_4 = user_2.reviews.create(title: "It was a book?", description: "Eh, it was ok.", rating: 3, book: book_2)
      review_5 = user_3.reviews.create(title: "My Favorite Book", description: "SO GOOD, EVERYONE READ THIS BOOK!", rating: 4, book: book_2)
      review_6 = user_4.reviews.create(title: "I should probably read it again", description: "Didn't really follow what was going on.", rating: 5, book: book_2)
      review_7 = user_1.reviews.create(title: "Scary Book", description: "0 Stars, too scary.", rating: 1, book: book_3)
      review_8 = user_1.reviews.create(title: "Scary Book", description: "0 Stars, too scary.", rating: 1, book: book_1)

      visit books_path
      click_link "Highest Rating"
      within "article.book_container-0" do
        expect(page).to have_content(book_2.title)
      end
      
      visit books_path
      click_link "Lowest Rating"
      within "article.book_container-0" do
        expect(page).to have_content(book_3.title)
      end
    end

    it 'shows statistics about all books' do
      book_1 = Book.create(title: "Oh no, ice zombies", pages: 600, publication_year: 2018)
      book_2 = Book.create(title: "Frozen: Zombie edition", pages: 600, publication_year: 2018)
      book_3 = Book.create(title: "Dragons on ice", pages: 600, publication_year: 2018)
      book_4 = Book.create(title: "Dragons wearing pants", pages: 600, publication_year: 2018)
      user_1 = User.create(name: "Hamburglar")
      user_2 = User.create(name: "Michael")
      user_3 = User.create(name: "Ricardo")
      user_4 = User.create(name: "Lance")
      review_1 = user_1.reviews.create(title: "Terrible book!", description: "Bitters retro mustache aesthetic biodiesel 8-bit.", rating: 5, book: book_1)
      review_2 = user_2.reviews.create(title: "Thrilling book", description: "Park iphone leggings put a bird on it.", rating: 5, book: book_1)
      review_3 = user_3.reviews.create(title: "Amazing book!", description: "I love this book so much. It's the best thing I've ever read!!!!!!.", rating: 4, book: book_1)
      review_4 = user_2.reviews.create(title: "It was a book?", description: "Eh, it was ok.", rating: 3, book: book_2)
      review_5 = user_3.reviews.create(title: "My Favorite Book", description: "SO GOOD, EVERYONE READ THIS BOOK!", rating: 3, book: book_2)
      review_6 = user_4.reviews.create(title: "I should probably read it again", description: "Didn't really follow what was going on.", rating: 2, book: book_4)
      review_7 = user_1.reviews.create(title: "Scary Book", description: "0 Stars, too scary.", rating: 1, book: book_2)
      review_8 = user_1.reviews.create(title: "Horrible", description: "This book was not informative. I would like a refund.", rating: 1, book: book_3)

      visit books_path
      
      within '#top-three' do
        expect(page).to have_content(book_1.title)
        expect(page).to have_content(book_2.title)
        expect(page).to have_content(book_4.title)
        expect(page).to_not have_content(book_3.title)
      end
      
      within '#bottom-three' do
        expect(page).to have_content(book_3.title)
        expect(page).to have_content(book_4.title)
        expect(page).to have_content(book_2.title)
        expect(page).to_not have_content(book_1.title)
      end
      
      within '#top-users' do
        expect(page).to have_content(user_1.name)
        expect(page).to have_content(user_2.name)
        expect(page).to have_content(user_3.name)
        expect(page).to_not have_content(user_4.name)
      end
    end
  end
end
