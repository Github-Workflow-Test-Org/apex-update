## Introduction / Scope

This is an update to our SFDC/Apex (salesforce.com) static research that includes support for Visualforce pages, Lightning (Aura) Components, Lightning Web Components, and updates to Apex.  This research covers up through Salesforce Summer '21 (SFDC API version 52.0).

The official repo for this research is [https://gitlab.laputa.veracode.io/research-roadmap/apex-update-202105](https://gitlab.laputa.veracode.io/research-roadmap/apex-update-202105) -- check there for updates.

Previous research repos (including specs and testcases):

* [https://gitlab.laputa.veracode.io/research-roadmap/apex-visualforce-lightning-201912](https://gitlab.laputa.veracode.io/research-roadmap/apex-visualforce-lightning-201912)
* [https://gitlab.laputa.veracode.io/research-roadmap/apex-visualforce](https://gitlab.laputa.veracode.io/research-roadmap/apex-visualforce)


## Apex Changes

### New Operator: Safe Navigation Operator (`?.`)

The safe navigation operator is a way to safely dereference objects that may be null without either an explicit null check or a risk of a null pointer exception.

It is used in expressions of the form `foo?.bar`, where `foo` is an object that may be null.  If `foo` is null, then the value of the expression is null; otherwise, it is the value of `foo.bar`.  (For modeling purposes, we can just treat them the same as normal `foo.bar` expressions.)

Some examples from the code:

```
a?.b // Evaluates to: a == null? Null : a.b

a[x]?.aMethod().aField // Evaluates to null if a[x] == null
```

This is similar to TypeScript/JavaScript's [optional chaining operator](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Nullish_coalescing_operator) or the C# [null-conditional operator](https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/operators/member-access-operators#null-conditional-operators--and-).  

More details on this operator can be found at [https://help.salesforce.com/articleView?id=release-notes.rn_apex_SafeNavigationOperator.htm&type=5&release=228](https://help.salesforce.com/articleView?id=release-notes.rn_apex_SafeNavigationOperator.htm&type=5&release=228).

### New DPA Rules: `JSONParser` class

```
* JSONParser OUT = JSON.createParser(IN)
* OUT = (JSONParser)IN.getBlobValue()
* OUT = (JSONParser)IN.getCurrentName()
* OUT = (JSONParser)IN.getText()
* OUT = (JSONParser)IN.readValueAs(x)
* OUT = (JSONParser)IN.readValueAsStrict(x)

```

### New Callback Interface / Taint Injection

The `Functions.FunctionCallback` interface may be implemented by Apex classes.  These classes' constructors are called by SFDC, and their first argument (of type `Functions.FunctionInvocation`) is tainted.  These methods can retrieve taint from a tainted `Functions.FunctionInvocation`:

```
* OUT = (Functions.FunctionInvocation)IN.getError()
* OUT = (Functions.FunctionInvocation)IN.getResponse()
```

Flaw example:

```
public with sharing class BadCallback implements functions.FunctionCallback {
    public BadCallback(functions.FunctionInvocation result) {
        String jsonResponse = result.getResponse();
        jsonparser parser = json.createParser(jsonResponse);
        parser.nextToken();
        parser.nextValue();
        List<object> objs = DATabase.QUery('select id, price__c, name from book__c where name like \'%' + parser.getText() + '%\'');        // CWEID 943
    }
```

## Visualforce Changes

### New function: `Visualforce.remoting.Manager.invokeAction`

In JS that is normalized from Visualforce pages (`.page` files), if the final argument to a `Visualforce.remoting.Manager.invokeAction()` call is a function, that function is called with network-tainted arguments.

## Lightning Web Components changes

### More type info

The standard HTML DOM APIs `Element.getElementsByTagName()` and `Element.getElementsByClassName()` (both of which return a collection of `Element`s, are now supported by LWC `LightningElement` classes.  If we're modeling these as `Element`s already, there shouldn't be anything more to do - they act just like the DOM versions of these calls.

Example:

```
    hgw51(event) {
        console.log("hgw51");
        console.log(event.target.value);
        let els = this.getElementsByTagName("span");
        if(els.item(0)) {
            els.item(0).innerHTML = "WHAT IS THIS " + event.target.value;       // CWEID 80
```

## Testcase

There is an additional test app that contains examples of these new features in this repo named [dxvforce2](testcases/dxvforce2).
