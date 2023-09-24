using Oxygen
using HTTP 
using Mustache



function render_html(html_file::String, context::Dict = Dict();status=200, headers=["Content-Type" => "text/html; charset=utf-8"]) :: HTTP.Response
    is_context_empty = isempty(context) === true 
    # return raw hmtl without context 
    if is_context_empty
        io = open(html_file,"r") do file 
            read(file, String)
        end
        template = io |> String 
    else 
        # Render html with context 
        io = open(html_file,"r") do file 
            read(file, String)
        end
        template = String(Mustache.render(io, context))
    end 
        return HTTP.Response(status, headers,body = template)
end 

    
# creating route
@get "/" function(req::HTTP.Request)
    return "Hello Julia Web App"
end 

# Serialize dict to json 
@get "/home" function(req::HTTP.Request)
    return Dict("name" => "Jesse")
end 

# Render HTML 
# @get "/generate" function(req::HTTP.Request)
#     render_html("index.html")
# end


# Render HTML  with context
@get "/generate" function(req::HTTP.Request)
    context = Dict("name" => "Jesse")
    return render_html("index.html", context)
end

# Receiving query params
# http://127.0.0.1:8001/query?books=bible
@get "/query" function(req::HTTP.Request)
    return queryparams(req)
end 


# Receiving form data 
@get "/generate/password" function(req::HTTP.Request)
    form_data = queryparams(req)
    fname = get(form_data,"fname","")
    context = Dict("fname" => fname)
    return render_html("generate.html", context)
end 


# path params 
# http://127.0.0.1:8001/{num1}/{num2}
@get "/add/{num1}/{num2}" function(req::HTTP.Request, num1::Float64, num2:: Float64)
    return num1 + num2
end 

# Routes : HOF for reuse 
api = router("/api", tags=["api endpoint"])

@get api("/add/{num1}/{num2}") function(req::HTTP.Request, num1::Float64, num2:: Float64)
    return num1 + num2
end 

@post api("/multiply/{num1}/{num2}") function(req::HTTP.Request, num1::Float64, num2:: Float64)
    return num1 * num2
end 


serve(port=8001)