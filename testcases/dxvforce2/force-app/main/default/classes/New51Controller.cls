global with sharing class New51Controller {
    public string xxzgood1 {get; private set; }
    public string xxzbad1 {get; private set; }
    public string xxzbad2 {get; private set; }
    public string xxzbad3 {get; private set; }
    public string xxzbad4 {get; private set; }
    public string xxzbad5 {get; private set; }
    public string xxzbad6 {get; private set; }
    public string xxzbad7 {get; private set; }
    public string xxzbad8 {get; private set; }
    private string carrier { get; private set; }

    public New51Controller() {
        this.carrier = ApexPages.currentPage().getParameters().get('foo');
        this.xxzbad1 = this?.carrier;

        JSONParser jp1 = JSON.createParser('{"foo": "bar"}');
        jp1.nextToken();
        jp1.nextValue();
        this.xxzgood1 = jp1.getText();
        
        JSONParser jp2 = JSON.createParser('{"foo": "' + this.carrier + '"}');
        jp2.nextToken();
        jp2.nextValue();
        this.xxzbad2 = jp2.getText();
        
        JSONParser jp3 = JSON.createParser('{"foo": "' + this.carrier + '"}');
        jp3.nextToken();
        jp3.nextValue();
        if(this.carrier.contains('whatever')) {
            this.xxzbad3 = jp3.getBlobValue().toString();
        }

        JSONParser jp4 = JSON.createParser('{"' + this.carrier + '": "bar"}');
        jp4.nextToken();
        jp4.nextValue();
        this.xxzbad4 = jp4.getCurrentName();

        JSONParser jp5 = JSON.createParser('{"' + this.carrier + '": "bar"}');
        jp5.nextToken();
        jp5.nextValue();
        this.xxzbad5 = jp5.readValueAs(String.class).toString();

        JSONParser jp6 = JSON.createParser('{"' + this.carrier + '": "bar"}');
        jp6.nextToken();
        jp6.nextValue();
        this.xxzbad6 = jp6.readValueAsStrict(String.class).toString();
    }

    @RemoteAction
    global static string getSomething(string inpval) {
        List<object> objs;

        try {
            objs = DATabase.QUery('select id, price__c, name from book__c where name like \'%' + inpval + '%\'');        // CWEID 943
            return 'heyo';
        } catch (Exception ex) {
            return 'exception';
        }
    }
}
