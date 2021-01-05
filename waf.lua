local content_length=tonumber(ngx.req.get_headers()['content-length'])
local method=ngx.req.get_method()
local ngxmatch=ngx.re.match
local cjson = require("cjson");

if whiteip() then
elseif blockip() then
elseif denycc() then
elseif ngx.var.http_Acunetix_Aspect then
    ngx.exit(444)
elseif ngx.var.http_X_Scan_Memo then
    ngx.exit(444)
elseif whiteurl() then
elseif ua() then
elseif url() then
elseif args() then
elseif cookie() then
elseif PostCheck then
    if method=="POST" then
		ngx.req.read_body()
		local args = ngx.req.get_body_data()
		local boundary = get_boundary()
		-- form表单形式 post传输
		if boundary then
			for v in string.gmatch(args, '[\n][^C]+') do
				--testlog("form-:"..s)
				body(v)
			end
		else
			-- 解析json格式 ,body json格式或者其它格式..
			-- username=admin&password=password
			local asArr = split(args,"&")
			if asArr then
				for key,val in pairs(asArr) do
					local subArr = split(val,"=")
					body(subArr[1])
				end
			else
				-- json格式
				local json = cjson.decode(args);
				checkJson(json)
			end
		end
    end
else
    return
end
