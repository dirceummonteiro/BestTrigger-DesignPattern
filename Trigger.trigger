trigger LUX_EmailMessageTrigger on EmailMessage (before insert,after insert) {
    new LUX_EmailMessageHandler().run();
}
