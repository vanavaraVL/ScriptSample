
# 1. The browser support rules with standard HTTP status code 403 (Forbidden)

There are two rules which allow to restrict browser client using except Chrome usage:

[BrowserSupportRule.xml](./src/BrowserRules/StandardHTTP/BrowserSupportRule.xml) 
Browser's support rule for browsers which are differ from Chrome and Safari

[BrowserSupportRuleSafari.xml](./src/BrowserRules/StandardHTTP/BrowserSupportRuleSafari.xml)
Browser's support rule for Safari browser only and is differ from Chrome

- The rules should be imported into IIS's UrlRewrite section:
```
IIS->Sites->Microsoft Dynamics CRM->Url Rewrite
```

- After import finishes, the rules should be Enabled

# 2. The browser support rules with custom HTTP status code 447 (custom HTTP status code)

## a) There are two rules which allow to restrict browser client using except Chrome usage and custom error page:

[BrowserSupportRule.xml](./src/BrowserRules/CustomHTTP/BrowserSupportRule.xml) 
Browser's support rule for browsers which are differ from Chrome and Safari

[BrowserSupportRuleSafari.xml](./src/BrowserRules/CustomHTTP/BrowserSupportRuleSafari.xml) 
Browser's support rule for Safari browser only and is differ from Chrome

[447.htm](./src/BrowserRules/CustomHTTP/447.htm) 
Custom error page

- The rules should be imported into IIS's UrlRewrite section:
```
IIS->Sites->Microsoft Dynamics CRM->Url Rewrite
```

- After import finishes, the rules should be Enabled

## b) 447.html should be copied into the folder path:
```
C:\Program Files\Microsoft Dynamics CRM\Server\CustomErrorPages\447.htm
```

## c) Custom error page should be included into IIS's Error Pages section
```
IIS->Sites->Microsoft Dynamics CRM->Error Pages
```

Add new error page with the next parameters:
```
Insert content with static file using the next file path
C:\Program Files\Microsoft Dynamics CRM\Server\CustomErrorPages\447.htm

Status code
447
```

## d) Allow absolute paths when delegate should be enabled at the MS Dynamics site
```
IIS->Sites->Microsoft Dynamics CRM->Configuration Editor
```

- Choice section by name: system.webServer/httpErrors

- Unlock section for allowAbsolutePathsWhenDelegated and set it from false to true

- Lock section for allowAbsolutePathsWhenDelegated back.


