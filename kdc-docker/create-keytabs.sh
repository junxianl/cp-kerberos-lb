echo "==================================================================================="
echo "==== Creating keytabs ===================== ======================================="
echo "==================================================================================="
rm -rf /keytabs/broker1.keytab
rm -rf /keytabs/broker2.keytab
rm -rf /keytabs/kafkaclient1.keytab
kadmin.local addprinc -randkey kafka/broker1.cp-kerberos-lb@EXAMPLE.COM
kadmin.local addprinc -randkey kafka/broker2.cp-kerberos-lb@EXAMPLE.COM
kadmin.local ktadd -norandkey -k /keytabs/broker1.keytab kafka/broker1.cp-kerberos-lb@EXAMPLE.COM
kadmin.local ktadd -norandkey -k /keytabs/broker2.keytab kafka/broker2.cp-kerberos-lb@EXAMPLE.COM
kadmin.local addprinc -randkey kafka/haproxy.cp-kerberos-lb@EXAMPLE.COM
kadmin.local ktadd -norandkey -k /keytabs/broker1.keytab kafka/haproxy.cp-kerberos-lb@EXAMPLE.COM
kadmin.local ktadd -norandkey -k /keytabs/broker2.keytab kafka/haproxy.cp-kerberos-lb@EXAMPLE.COM
kadmin.local addprinc -randkey kafkaclient1
kadmin.local ktadd -norandkey -k /keytabs/kafkaclient1.keytab kafkaclient1

echo "Keytabs done!"
