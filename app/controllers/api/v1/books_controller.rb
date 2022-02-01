

class Api::V1::BooksController < ApplicationController
      MAX_PAGINATION_LIMIT = 100
      def index
        books = Book.limit(limit).offset(params[:offset])

        render json: BooksRepresenter.new(books).as_json
      end

      def create 
        author = Author.create!(author_params)
        # binding.irb
        # book = Book.new(title:book_params[:title], author:author)
        book = Book.new(book_params.merge(author_id:author.id))
        if book.save
          render json: BookRepresenter.new(book).as_json, status: :created
        else
          render json: book.errors, status: :unprocessable_entity
        end
      end

      def destroy
        book = Book.find(params[:id]).destroy!
        head :no_content
      end
      
      def limit 
        [
          params.fetch(:limit, MAX_PAGINATION_LIMIT).to_i, #fetch ele chama limit, se n houver, coloca o default como MAX_PAGINATION_LIMIT
          MAX_PAGINATION_LIMIT
        ].min 
      end


      def book_params
        params.require(:book).permit(:title)
      end

      def author_params
        params.require(:author).permit(:first_name, :last_name, :age)
      end

    end