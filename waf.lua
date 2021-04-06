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
                        if args ~= nil then
                                testlog(args)
                                args = decodeURI(args)
                                testlog(args)
                        end
                local boundary = get_boundary()
                -- 过滤传输文件,将所有传输文件的作为白名单过滤，不做校验
                if get_multipart() and boundary == nil then
                        testlog("come in multipart-form verify")
                else
                        -- form表单形式 post传输
                        testlog("come in form verify")
                        if boundary then
                                testlog("come in boundary verify")
                                if args ~= nil then
                                        for v in string.gmatch(args, '[\n][^C]+') do
                                                if v ~= nil then
                                                        body(v)
                                                end
                                        end
                                end
                        else
                                -- 解析json格式 ,body json格式或者其它格式..
                                -- username=admin&password=password
                                if args then
                                        local asArr = split(args,"&")
                                        local urlencoded = isFormUrlEncoded()
                                        if #asArr > 1 or urlencoded then
                                                testlog("come in urlencoded verify")
                                                for key,val in pairs(asArr) do
                                                                testlog(key..":"..val)
                                                                local subArr = split(val,"=")
                                                                if subArr[2] ~= nil then
                                                                        testlog(subArr[2])
                                                                        body(subArr[2])
                                                                end
                                                end
                                        else
                                                -- json格式
                                                testlog("come in json")
                                                local json = cjson.decode(args);
                                                checkJson(json)
                                        end
                                end
                        end
                end
    end
else
        testlog("come in return");
    return
end
