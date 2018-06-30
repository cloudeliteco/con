<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_amount_field</fullName>
        <description>to update the amount field with claim amount</description>
        <field>Amount</field>
        <formula>Claim_Amount__c</formula>
        <name>Update amount field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>match_Bankruptcy_name</fullName>
        <field>Name</field>
        <formula>Bankrupcy__r.Name &amp; &quot;  for  &quot; &amp; Account.Name</formula>
        <name>match Bankruptcy name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Mark amount field</fullName>
        <actions>
            <name>Update_amount_field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Claim_Amount__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>this workflow will make sure the amount field on currency is populated</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>update the opportunity name</fullName>
        <actions>
            <name>match_Bankruptcy_name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>this will make the opportunity name match the bankruptcy</description>
        <formula>Bankrupcy__c  &lt;&gt; null</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
