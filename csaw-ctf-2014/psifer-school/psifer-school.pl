#!/usr/bin/perl -w

# By Black-ID
#@Go Back 
#CSAW 2014


use IO::Socket;
use POSIX;
use warnings;
no warnings;

my $server = "54.209.5.48";
my $port = 12345;

# Create new Socket
my $sock = new IO::Socket::INET(PeerAddr => $server,PeerPort => $port,Proto => 'tcp') or die "Can't connect\n";

# Log on to CSAW server.

sub caesarCipher { 
  $strText = $_[0];
  $iShiftValue = $_[1];

  my $strCipherText = "";
  @strTextArray = split(//, $strText);

  $iShift = $iShiftValue % 26;
  if ($iShift < 0) {
    $iShift += 26;
  }

  $i = 0;
  while ($i < length($strText)) {
    $c = uc($strTextArray[$i]);
    if ( ($c ge 'A') && ($c le 'Z') ) {
      if ( chr(ord($c) + $iShift) gt 'Z') {
        $strCipherText .= chr(ord($c) + $iShift - 26);
      } else {
        $strCipherText .= chr(ord($c) + $iShift);
      }
    } else {
      $strCipherText .= " ";
    }
    $i++;
  }
  return lc($strCipherText);
}

sub scytaleCipher {
  $strText = $_[0];
  $iShiftValue = $_[1];
  
  my $strCipherText = "";
  @strTextArray = split //, $strText;
  $M = length($strText);
  $iShift = floor($M/$iShiftValue);
  
  if ($iShift*$iShiftValue < $M) {
  $iShift++;
  }
  for($a=0;$a<$iShiftValue;$a++) {
    for($i=0;$i<$iShift;$i++) {
    $strCipherText .= $strTextArray[$a+$i*$iShiftValue];
    }
  }
  return $strCipherText;
 } 
 sub vigenerebrute{
     $strChiper = $_[0];
	 $strCipherText = "";
	 $a = 0;
	  for($a=0;$a<10;$a++) {
     @chars = split(//, "abcdefghijklmnopqrstuvwxyz");
	 #print $chars[0];
	 for($i=0;$i<26;$i++) {
     $output = decrypt_string($strChiper,$chars[$i]);
	 @out = split(//, $output);
	 @cmp = split(//, "thistimewewillgive");
	 #print $out[$i];
	 if($out[$a] eq $cmp[$a]) {
	 $strCipherText .= $chars[$i];
	 }
	 }
	 $output = decrypt_string($strChiper,$strCipherText);
	 if($output =~ /thistimewewillgive(.*)/){
	 last;
	 }
	 }
	 if ($output =~ /righthere(.*)oknow/){
	 return $1;
	 }
	 

}
sub decrypt_string{
	my ($ciphertext, $key) = @_;
	my $plaintext;
	$key = $key x (length($ciphertext) / length($key) + 1);
	for( my $i=0; $i<length($ciphertext); $i++ ){
		$plaintext .=
			decrypt_letter( (substr($ciphertext,$i,1)),  (substr($key,$i,1)));
	}
	return $plaintext;
}
sub decrypt_letter{
	my ($cipher, $row) = @_;
	my $plain;
	$row 	= ord(lc($row))    - ord('a');
	$cipher = ord(lc($cipher)) - ord('a');
	$plain  = ($cipher - $row) % 26;
	
	$plain = chr($plain + ord('a'));

	return lc($plain);
}

$sock->recv($data,1024);
print $data;
$sock->recv($data,1024);
print $data;
if($data =~ m/psifer text: (.+)$/g){
$cipher = $1; 
print "\nEncoded: $cipher\n";
for($a=0;$a<=26;$a++) {

$st = caesarCipher($cipher, $a);
if ($st =~ /the answer(.*)/){
print "\nDecoded: $st\n";
$ccipher = substr $st, 28; 
$sock->send($ccipher."\n");
print "\nKey: $ccipher\n";
}
}
}
$sock->recv($data,1024);
print $data;
if($data =~ /psifer text: (.*)/){
$cipher = $1; 
print "\nEncoded: $cipher\n";
for($a=1;$a<=300;$a++) {
$st = scytaleCipher ($cipher,$a);
if ($st =~ /I hope you(.*)/){
print "[$a]  =>  $st\n";
if($st =~ /"(.+?)"/){
$key = $1;
print "\nkey is : $key\n";
$sock->send($key."\n");

} 
}
}

}
$sock->recv($data,1024);
print $data;
if($data =~ /psifer text: (.*)/){
$cipher = $1; 
$cipher =~ s/\s+//g;
print "\nEncoded: $cipher\n"; 
$key = vigenerebrute($cipher);
print "\nkey is : $key\n";
$sock->send($key."\n");
$sock->recv($data,1024);
print $data;
$sock->recv($data,1024);
print $data;
}

