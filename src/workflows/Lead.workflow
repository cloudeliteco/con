<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <rules>
        <fullName>SendMailing</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Lead.Claim_Amount__c</field>
            <operation>greaterOrEqual</operation>
            <value>20000</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
