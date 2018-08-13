<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_purchase_amount</fullName>
        <description>this is to make sure the purchase amount is updated when purchase price changed, this is to multiply purchase price by quantity</description>
        <field>Purchase_Amount__c</field>
        <formula>Purchased_price__c  *  Quantity</formula>
        <name>Update purchase amount</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>calculate new purchase amount</fullName>
        <actions>
            <name>Update_purchase_amount</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>this is to trigger change to purchase price</description>
        <formula>ISCHANGED(Purchased_price__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
