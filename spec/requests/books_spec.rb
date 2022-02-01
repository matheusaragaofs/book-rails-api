require 'rails_helper'
describe 'Books API', type: :request do
    let(:first_author) { FactoryBot.create(
        :author, 
        first_name:'George',
        last_name:"Orwell",
        age:46
    )}
    let(:second_author) { FactoryBot.create(
        :author, 
        first_name:'Alan',
        last_name:"Rick",
        age:46
    )}

    describe "GET /books" do

        before do 
            FactoryBot.create(:book , title:'1984', author: first_author)
            FactoryBot.create(:book , title:'The Time Machine', author: second_author)
        end

          it 'returns all books' do
            
            get '/api/v1/books'
            
            expect(response).to have_http_status(:success)  
            expect(response_body.size).to eq(2)  
            expect(response_body).to eq(
                [
                {
                "id"=> 1,
                "title"=> '1984',
                "author_name"=> 'George Orwell',
                "author_age"=> 46
                
                },
                {
                "id"=> 2,
                "title"=> 'The Time Machine',
                "author_name"=> 'Alan Rick',
                "author_age"=> 46
                
                },
            ]
        )
        end
        it 'returns a subset of books based on limit' do
             get '/api/v1/books' , params: {limit: 1}
            expect(response).to have_http_status(:success)  
            expect(response_body.size).to eq(1)  
            expect(response_body).to eq(
                [
                { 
                "id"=> 1,
                "title"=> '1984',
                "author_name"=> 'George Orwell',
                "author_age"=> 46
                
                }
            ]
        )
        end
        it 'returns a subset of books based on limit and offset' do
             get '/api/v1/books' , params: {limit: 1, offset: 1}
            expect(response).to have_http_status(:success)  
            expect(response_body.size).to eq(1)  
            expect(response_body).to eq(
                [
                {
                    "id"=> 2,
                    "title"=> 'The Time Machine',
                    "author_name"=> 'Alan Rick',
                    "author_age"=> 46
                    
                    },
            ]
        )
        end
        it 'has a max limit of 100' do
            expect(Book).to receive(:limit).with(100).and_call_original
            get '/api/v1/books', params: { limit: 999, offset:1}

        end
        
    end
    
    describe "POST /books" do
        it 'creates a new book' do 
            expect {
                post '/api/v1/books', params: {
                    book:{title:"The Marcian"},
                    author:{first_name:'Andy', last_name:'Weir',age:48}}
            }.to change { Book.count }.from(0).to(1) #conta se há mudanças no número de linhas da tabela.
            
            expect(response).to have_http_status(:created)
            
            expect(Author.count).to eq(1)
            expect(response_body).to eq(
                {
                "id"=> 1,
                "title"=> 'The Marcian',
                "author_name"=> 'Andy Weir',
                "author_age"=> 48
                
                }
        )
        end 
    end
    
    describe "DELETE /books/:id" do
        let!(:book) {FactoryBot.create(:book , title:'1981', author:first_author)} #pra forçar a invocação do let(:book) usa !

        it 'deletes a book' do
            # expect(Book.find_by(id:book.id)).to be_nil
            expect {
                delete "/api/v1/books/#{book.id}"
            }.to change { Book.count }.from(1).to(0)
            expect(response).to have_http_status(:no_content)  
        end
    end
end