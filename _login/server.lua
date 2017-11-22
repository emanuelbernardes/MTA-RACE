
addEvent("onRequestLogin",true)
addEventHandler("onRequestLogin",root,
function( login, password)
    login = tostring(login)
	password = tostring(password)
	if not ( login == "") then
		if not ( password == "") then
			local account = getAccount ( login, password )
			if ( account ~= false ) then
			    logIn( source, account, password )
				triggerClientEvent( source, "saveLoginToXML", root, login, password )
				triggerClientEvent( source, "removeLogin", root )
				triggerClientEvent( source,"createMessage",root,"Logado com Sucesso, Tenha um Bom Jogo!","",0,255,0)
			else
				triggerClientEvent( source,"createMessage",root,"Usuario ou senha incorreta!","",255,0,0)
			end
		else	
			triggerClientEvent( source,"createMessage",root,"Preencha a Senha!","",255,255,255)
		end
	else
	    triggerClientEvent( source,"createMessage",root,"Preencha o Usuario!","",255,255,255)
	end
end
)

addEvent("onRequestRegister",true)
addEventHandler("onRequestRegister",getRootElement(),
function ( login, password, passwordAgain)
    login = tostring(login)
	password = tostring(password)
	passwordAgain = tostring(passwordAgain)
	if not ( login == "") then
		if not ( password == "") then
			if not ( passwordAgain == "") then
				if password == passwordAgain then
					local account = getAccount ( login, password )
					if ( account == false ) then
						local accountAdded = addAccount( login , password )
						if ( accountAdded ) then
						    triggerClientEvent( source, "returnLogin", root )
							triggerClientEvent( source,"createMessage",root,"Registro Efetuado!","",0,255,0)
						else
							triggerClientEvent( source,"createMessage",root,"Erro! Tente outro usuario ou outra senha!","",255,0,0)
						end
					else
					    triggerClientEvent( source,"createMessage",root,"Este usuario ja existe!","",255,0,0)
					end
				else
				    triggerClientEvent( source,"createMessage",root,"As senhas nao sao iguais!","",255,0,0)
				end
			else
			    triggerClientEvent( source,"createMessage",root,"Repita a senha!","",255,255,255)
			end
		else
			triggerClientEvent( source,"createMessage",root,"Preencha a Senha!","",255,255,255)
		end
	else
		triggerClientEvent( source,"createMessage",root,"Preencha o Usuario!","",255,255,255)
	end
end
)