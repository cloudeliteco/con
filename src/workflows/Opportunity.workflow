<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Active_field</fullName>
        <description>this to mark active field to closed lost.</description>
        <field>Active__c</field>
        <literalValue>0</literalValue>
        <name>Update Active field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>match_Bankruptcy_name</fullName>
        <field>Name</field>
        <formula>Bankrupcy__r.Name &amp; &quot;  for  &quot; &amp; Account.Name  &amp; &quot; - &quot; &amp; Auto_Number__c</formula>
        <name>match Bankruptcy name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Mark Active field</fullName>
        <actions>
            <name>Update_Active_field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Closed Lost</value>
        </criteriaItems>
        <description>this will update the active field when stage changes to closed lost.</description>
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
