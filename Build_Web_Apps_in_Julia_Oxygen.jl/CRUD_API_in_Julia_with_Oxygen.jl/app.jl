using Oxygen
using HTTP
using StructTypes

# CRUD API

# Struct to Store Data /Model Schema
struct BlogPost 
    id::Int 
    title::String 
    content::String
 end

 # Add support for JSON serialization and deserialize
 StructTypes.StructType(::Type{BlogPost}) = StructTypes.Struct()

 # DATABASE
 using SQLite
 db_path = "blog.sqlite"
 db = SQLite.DB(db_path)

 SQLite.execute(db, "CREATE TABLE IF NOT EXISTS blogpost(id INTEGER PRIMARY KEY,title TEXT NOT NULL,content TEXT NOT NULL)")


 # SQL functions for CRUD 
function create_blog(blogpost::BlogPost)
    DBInterface.execute(db,"INSERT INTO blogpost (title,content) VALUES (?,?)",(blogpost.title,blogpost.content))
    return 
end

function read_all_blog()
    result = DBInterface.execute(db,"SELECT * FROM blogpost")
    return [BlogPost(row[1], row[2], row[3]) for row in result]
end

function read_blog(id::Int)
    result =  DBInterface.execute(db, "SELECT * FROM blogpost  WHERE id = ?", (id,))
    if !isempty(result)
        row = first(result)
        return BlogPost(row[1], row[2], row[3])
    else
        return nothing
    end
end

function update_blog(blogpost::BlogPost)
    DBInterface.execute(db, "UPDATE blogpost SET title = ?, content = ? WHERE id = ?", (blogpost.title, blogpost.content, blogpost.id))
end

function delete_blog(id::Int)
    DBInterface.execute(db,"DELETE FROM blogpost WHERE id = ?", (id,))
    return nothing
end



# Create Endpoint
@post "/api/v1/blogs/" function(req::HTTP.Request)
    data = json(req,BlogPost) # convert the request body to struct 
    create_blog(data)
    return data
end

@get "/api/v1/blogs/" function(req::HTTP.Request)
    data = read_all_blog()
    return data
end

@get "/api/v1/blogs/{blog_id}" function(req::HTTP.Request,blog_id::Int)
    data = read_blog(blog_id)
    return data
end

@patch "/api/v1/blogs/{blog_id}" function(req::HTTP.Request,blog_id::Int)
    data = json(req,BlogPost)
    data = update_blog(data)
    return data
end


@delete "/api/v1/blogs/{blog_id}" function(req::HTTP.Request,blog_id::Int)
    return delete_blog(blog_id)
end






serve(port=8001)