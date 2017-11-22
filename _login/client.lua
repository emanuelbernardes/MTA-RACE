outputDebugString("Gw8_Login ON!! =D")
sX,sY = guiGetScreenSize()
function resX(value)
    return (value/1920)*sX
end
function resY(value)
    return (value/1080)*sY
end
removeCache()

fonts = {}
function dxFont(index)
    if not fonts[index] then
	    fonts[index] = dxCreateFont(':race/addons/font.ttf',index) or "defaul-bold"
	end
    return fonts[index]
end

function XML()
    xml = xmlLoadFile("files/xml/userdata.xml")
	if not xml then
	    xml = xmlCreateFile ("files/xml/userdata.xml","editbox")
		usernameChild = xmlCreateChild(xml,"username")
        passwordChild = xmlCreateChild(xml,"password")
    else
	    usernameChild = xmlFindChild(xml,"username",0)
        passwordChild = xmlFindChild(xml,"password",0)
	end
	usernameLoad = xmlNodeGetValue(usernameChild)
    passwordLoad = xmlNodeGetValue(passwordChild)
	for w in string.gmatch(usernameLoad,".") do
        for i,box in ipairs(editBox) do
            if box.editName == "username" then
                table.insert(text[i],w)
            end
        end
    end
    for w in string.gmatch(passwordLoad,".") do
        for i,box in ipairs(editBox) do
            if box.editName == "password" then
                table.insert(text[i],w)
            end
        end
    end
end

pageiD = 1
state = true
alpha = {0,0,0}
pg = 0

function draw()
    pg=pg+0.001
    if state then
		alpha[3]=interpolateBetween(alpha[3],0,0,1,0,0,pg,"Linear")
	else
        alpha[3]=interpolateBetween(alpha[3],0,0,0,0,0,pg,"Linear")
		if alpha[3] <= 0.01 then
		    removeEventHandler("onClientRender",root,draw)
		end
	end
	if alpha[pageiD] then
		alpha[pageiD]=interpolateBetween(alpha[pageiD],0,0,1,0,0,pg,"Linear")
	end
	dxDrawImage(sX/2-resX(250),sY/2-resY(250),resX(500),resY(200),"logo.png",0,0,0,tocolor(255,255,255,255*alpha[3]))
	if pageiD == 1 then
		createEditBox(sX*0.425,sY*0.5,sX*0.15,sY*0.03,1*alpha[3]*alpha[pageiD],resY(1.0),dxFont(15),"username","USUARIO")
		createEditBox(sX*0.425,sY*0.55,sX*0.15,sY*0.03,1*alpha[3]*alpha[pageiD],resY(1.0),dxFont(15),"password","SENHA")
		createButton(sX*0.425,sY*0.6,sX*0.07,sY*0.03,"REGISTRAR",255,155,0,1*alpha[3]*alpha[pageiD],resY(1.0),dxFont(15))
		createButton(sX*0.505,sY*0.6,sX*0.07,sY*0.03,"LOGAR",0,236,0,1*alpha[3]*alpha[pageiD],resY(1.0),dxFont(15))
		dxDrawImage(sX*0.575-sY*0.03,sY*0.49-sY*0.03,sY*0.03,sY*0.03,"close.png",0,0,0,tocolor(255,255,255,200*alpha[3]*alpha[pageiD]))
		if isMousePosition(sX*0.575-sY*0.03,sY*0.49-sY*0.03,sY*0.03,sY*0.03) then
		    dxDrawImage(sX*0.575-sY*0.03,sY*0.49-sY*0.03,sY*0.03,sY*0.03,"close.png",0,0,0,tocolor(255,0,0,200*alpha[3]*alpha[pageiD]))
		end
	elseif pageiD == 2 then
	    dxDrawImage(sX*0.575-sY*0.03,sY*0.49-sY*0.03,sY*0.03,sY*0.03,"return.png",0,0,0,tocolor(255,255,255,200*alpha[3]*alpha[pageiD]))
		if isMousePosition(sX*0.575-sY*0.03,sY*0.49-sY*0.03,sY*0.03,sY*0.03) then
		    dxDrawImage(sX*0.575-sY*0.03,sY*0.49-sY*0.03,sY*0.03,sY*0.03,"return.png",0,0,0,tocolor(255,48,48,200*alpha[3]*alpha[pageiD]))
		end
	    createEditBox(sX*0.425,sY*0.5,sX*0.15,sY*0.03,1*alpha[3]*alpha[pageiD],resY(1.0),dxFont(15),"username","USUARIO")
		createEditBox(sX*0.425,sY*0.55,sX*0.15,sY*0.03,1*alpha[3]*alpha[pageiD],resY(1.0),dxFont(15),"password","SENHA")
        createEditBox(sX*0.425,sY*0.6,sX*0.15,sY*0.03,1*alpha[3]*alpha[pageiD],resY(1.0),dxFont(15),"confirm","REPITA SENHA")
		createButton(sX*0.45,sY*0.65,sX*0.1,sY*0.03,"REGISTRAR",255,155,0,1*alpha[3]*alpha[pageiD],resY(1.0),dxFont(15))
	end
end

function but(button,state)
	if (button=="left" and state=="down") then
	    boxClick = false
		return false
    end
	    if pageiD == 1 then
			if isMousePosition(sX*0.425,sY*0.5,sX*0.15,sY*0.03) then
			    for i,box in ipairs(editBox) do
	    			if box.editName == "username" then
			   	    	boxClick = i
					end
				end
			end
			if isMousePosition(sX*0.425,sY*0.55,sX*0.15,sY*0.03) then
			    for i,box in ipairs(editBox) do
					if box.editName == "password" then
			    		boxClick = i
					end
				end
			end
			if isMousePosition(sX*0.425,sY*0.6,sX*0.07,sY*0.03) then
		    	removeCache()
				pageiD = 2
				pg = 0
				return
			end
			if isMousePosition(sX*0.505,sY*0.6,sX*0.07,sY*0.03) then
			    for i,box in ipairs(editBox) do
	        		if box.editName == "password" then
			    		box.text = table.concat(text[i],"")
						_password = box.text
					elseif box.editName == "username" then
			    		box.text = table.concat(text[i],"")
						_login = box.text
					end
				end
		        triggerServerEvent("onRequestLogin",localPlayer,_login,_password)
			end
			if isMousePosition(sX*0.575-sY*0.03,sY*0.49-sY*0.03,sY*0.03,sY*0.03) then
			    Remove()
			end
		elseif pageiD == 2 then
		    if isMousePosition(sX*0.425,sY*0.5,sX*0.15,sY*0.03) then
			    for i,box in ipairs(editBox) do
	    			if box.editName == "username" then
			   	    	boxClick = i
					end
				end
			end
			if isMousePosition(sX*0.425,sY*0.55,sX*0.15,sY*0.03) then
			    for i,box in ipairs(editBox) do
					if box.editName == "password" then
			    		boxClick = i
					end
				end
			end
			if isMousePosition(sX*0.425,sY*0.6,sX*0.15,sY*0.03) then
			    for i,box in ipairs(editBox) do
					if box.editName == "confirm" then
			    		boxClick = i
					end
				end
			end
			if isMousePosition(sX*0.45,sY*0.65,sX*0.1,sY*0.03) then
			    for i,box in ipairs(editBox) do
					if box.editName == "password" then
			    		box.text = table.concat(text[i],"")
						_password = box.text
					elseif box.editName == "confirm" then
			    		box.text = table.concat(text[i],"")
						_confirm = box.text
					elseif box.editName == "username" then
			    		box.text = table.concat(text[i],"")
						_login = box.text	
					end
				end
			    triggerServerEvent("onRequestRegister",localPlayer,_login,_password,_confirm)
			end
			if isMousePosition(sX*0.575-sY*0.03,sY*0.49-sY*0.03,sY*0.03,sY*0.03) then
			    removeCache()
				XML()
				pageiD = 1
				alpha[1] = 0
				pg = 0
				return
			end
		end	
	for i=1,2 do
	    if i~= pageiD then
		    alpha[i] = 0
		end
	end
end	

toggleAllControls(false)
showChat(false)
showCursor(true)
setElementData(localPlayer,"login",false)
XML()
addEventHandler("onClientRender",root,draw)
addEventHandler("onClientClick",root,but)

function Remove()
    showCursor(false)
    toggleAllControls(true)
    showChat(true)
	pg = 0
	state = false
	setElementData(localPlayer,"login",true)
	removeEventHandler("onClientClick",root,but)
end
addEvent("removeLogin",true)
addEventHandler("removeLogin",root,Remove)

function returnBut()
    pageiD=1
	pg=0
	for i=1,2 do
	    if i~= pageiD then
		    alpha[i] = 0
		end
	end
	removeCache()
	XML()
end
addEvent("returnLogin",true)
addEventHandler("returnLogin",root,returnBut)

addEvent("saveLoginToXML",true)
addEventHandler("saveLoginToXML",root,
function(login,password)
    xmlNodeSetValue(usernameChild,login)
    xmlNodeSetValue(passwordChild,password)
    xmlSaveFile(xml)
end
)

fileDelete("client.lua")