public with sharing class BadCallback implements functions.FunctionCallback {
    public BadCallback(functions.FunctionInvocation result) {
        String jsonResponse = result.getResponse();
        jsonparser parser = json.createParser(jsonResponse);
        parser.nextToken();
        parser.nextValue();
        List<object> objs = DATabase.QUery('select id, price__c, name from book__c where name like \'%' + parser.getText() + '%\'');        // CWEID 943

        objs = DATabase.QUery('select id, price__c, name from book__c where name like \'%' + result.getError() + '%\'');        // CWEID 943
    }
}
