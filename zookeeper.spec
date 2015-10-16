%global commit          601207e1151b2691112c431fc3b4130a85ac93b5
%global shortcommit     %(c=%{commit}; echo ${c:0:7})
%global _hardened_build 1
%global skiptests       1

Name:          zookeeper
Version:       3.4.6
Release:       10%{?dist}
Summary:       A high-performance coordination service for distributed applications
License:       ASL 2.0 and BSD
URL:           http://zookeeper.apache.org/
Source0:       https://github.com/apache/zookeeper/archive/%{commit}/%{name}-%{version}-%{shortcommit}.tar.gz
Source1:       %{name}-ZooInspector-template.pom
Source2:       %{name}.service
Source3:       zkEnv.sh

Patch1:        %{name}-3.4.5-zktreeutil-gcc.patch
Patch2:        %{name}-3.4.6-ivy-build.patch
Patch3:        %{name}-3.4.6-server.patch
# patch accepted in 3.5.0
Patch4:        https://issues.apache.org/jira/secure/attachment/12570030/mt_adaptor.c.patch


BuildRequires: autoconf
BuildRequires: automake
BuildRequires: boost-devel
BuildRequires: cppunit-devel
BuildRequires: dos2unix
BuildRequires: doxygen
BuildRequires: graphviz
BuildRequires: java-devel
BuildRequires: java-javadoc
BuildRequires: jpackage-utils
BuildRequires: libtool
BuildRequires: libxml2-devel
BuildRequires: log4cxx-devel
BuildRequires: python-devel

BuildRequires: ant
BuildRequires: ant-junit
BuildRequires: apache-ivy
BuildRequires: checkstyle
BuildRequires: ivy-local
BuildRequires: javapackages-tools

BuildRequires: jtoaster
BuildRequires: junit
BuildRequires: jdiff
%if 0%{?fedora} >= 21
BuildRequires: mvn(org.slf4j:slf4j-log4j12)
BuildRequires: objectweb-pom
BuildRequires: jline1
BuildRequires: netty3
Requires:      log4j12
%else
BuildRequires: mvn(log4j:log4j)
BuildRequires: jline
BuildRequires: netty
Requires:      log4j
%endif

BuildRequires: json_simple

BuildRequires: mockito
BuildRequires: slf4j
BuildRequires: xerces-j2
BuildRequires: xml-commons-apis

# remove later on.
BuildRequires: apache-commons-parent
BuildRequires: jetty-server
BuildRequires: jetty-servlet
BuildRequires: systemd

Requires:      checkstyle
Requires:      jline1
Requires:      jtoaster
Requires:      junit
Requires:      mockito
Requires:      netty3
Requires:      slf4j
Requires:      java
Requires:      jpackage-utils
Requires:      %{name}-java = %{version}-%{release}

%description
ZooKeeper is a centralized service for maintaining configuration information,
naming, providing distributed synchronization, and providing group services.

##############################################
%package devel
Summary:       Development files for the %{name} library
Requires:      %{name}%{?_isa} = %{version}-%{release}

%description devel
Development files for the ZooKeeper C client library.

##############################################
%package java
Summary:        Java interface for %{name}
Group:          Development/Libraries
Requires:       %{name}%{?_isa} = %{version}-%{release}

%description java
The %{name}-java package contains Java bindings for %{name}.

##############################################
%package javadoc
Summary:       Javadoc for %{name}
BuildArch:     noarch

%description javadoc
This package contains javadoc for %{name}.

%package -n python-%{name}
Summary:       Python support for %{name}
Requires:      %{name}%{?_isa} = %{version}-%{release}
Provides:      zkpython%{?_isa} = %{version}-%{release}
Requires:      python2

%description -n python-%{name}
The python-%{name} package contains Python bindings for %{name}.

%prep
%setup -q -n %{name}-%{commit}

%patch1 -p0
%patch2 -p1
%patch3 -p1
%patch4 -p0 -F2

iconv -f iso8859-1 -t utf-8 src/c/ChangeLog > src/c/ChangeLog.conv && mv -f src/c/ChangeLog.conv src/c/ChangeLog
sed -i 's/\r//' src/c/ChangeLog

sed -i 's|<exec executable="hostname" outputproperty="host.name"/>|<!--exec executable="hostname" outputproperty="host.name"/-->|' build.xml
sed -i 's|<attribute name="Built-On" value="${host.name}" />|<attribute name="Built-On" value="${user.name}" />|' build.xml

sed -i 's@^dataDir=.*$@dataDir=%{_sharedstatedir}/zookeeper/data\ndataLogDir=%{_sharedstatedir}/zookeeper/log@' conf/zoo_sample.cfg

%build
%ant -Divy.mode=local \
-DCLASSPATH=/usr/share/java/log4j12-1.2.17.jar \
-Dtarget.jdk=1.5 \
-Djavadoc.link.java=%{_javadocdir}/java \
-Dant.build.javac.source=1.5 \
-Dant.build.javac.target=1.5 \
package

pushd src/c
autoreconf -if
%configure --disable-static --disable-rpath
%{__make} %{?_smp_mflags}
popd

## TODO: install utilities?

%check
%if %skiptests
  echo "Testing disabled, please enable in mock"
%else
  %ant -Divy.mode=local test
%endif

%install

# the following is used to update zkEnv.sh
# find . -name "*.jar" -exec basename {} \; |sort|uniq
# remove items that don't belong and update execute build-classpath

#install the c tools
pushd src/c
%make_install
popd

# install the java dependencies.
mkdir -p %{buildroot}%{_javadir}/%{name}
install -pm 644 build/%{name}-%{version}.jar %{buildroot}%{_javadir}/%{name}/%{name}.jar
install -pm 644 build/%{name}-%{version}-test.jar %{buildroot}%{_javadir}/%{name}/%{name}-tests.jar
install -pm 644 build/contrib/ZooInspector/%{name}-%{version}-ZooInspector.jar %{buildroot}%{_javadir}/%{name}/%{name}-ZooInspector.jar

install -pm 755 bin/zkCleanup.sh %{buildroot}%{_bindir}
install -pm 755 bin/zkCli.sh %{buildroot}%{_bindir}
install -pm 755 bin/zkServer.sh %{buildroot}%{_bindir}
mkdir -p %{buildroot}%{_libexecdir}
install -pm 755 %{SOURCE3} %{buildroot}%{_libexecdir}

%if 0%{?fedora} >= 21
mkdir -p %{buildroot}%{_datadir}/maven-metadata
mkdir -p %{buildroot}%{_datadir}/maven-poms
install -pm 644 build/%{name}-%{version}/dist-maven/%{name}-%{version}.pom %{buildroot}%{_datadir}/maven-poms/%{name}-%{name}.pom

%add_maven_depmap %{name}-%{name}.pom %{name}/%{name}.jar
%add_maven_depmap org.apache.zookeeper:zookeeper::tests:%{version} %{name}/%{name}-tests.jar

install -pm 644 %{SOURCE1} %{buildroot}%{_datadir}/maven-poms/%{name}-%{name}-ZooInspector.pom
sed -i "s|@version@|%{version}|" %{buildroot}%{_datadir}/maven-poms/%{name}-%{name}-ZooInspector.pom
%add_maven_depmap %{name}-%{name}-ZooInspector.pom %{name}/%{name}-ZooInspector.jar
%else
mkdir -p %{buildroot}%{_mavenpomdir}
install -pm 644 build/%{name}-%{version}/dist-maven/%{name}-%{version}.pom %{buildroot}%{_mavenpomdir}/JPP.%{name}-%{name}.pom

%add_maven_depmap JPP.%{name}-%{name}.pom %{name}/%{name}.jar
%add_maven_depmap org.apache.zookeeper:zookeeper::tests:%{version} %{name}/%{name}-tests.jar

install -pm 644 %{SOURCE1} %{buildroot}%{_mavenpomdir}/JPP.%{name}-%{name}-ZooInspector.pom
sed -i "s|@version@|%{version}|" %{buildroot}%{_mavenpomdir}/JPP.%{name}-%{name}-ZooInspector.pom
%add_maven_depmap JPP.%{name}-%{name}-ZooInspector.pom %{name}/%{name}-ZooInspector.jar
%endif

mkdir -p %{buildroot}%{_javadocdir}/%{name}
cp -pr build/docs/api/* %{buildroot}%{_javadocdir}/%{name}/

pushd src/contrib/zkpython
%{__python} src/python/setup.py build --build-base=$PWD/build \
install --root=%{buildroot} ;\
chmod 0755 %{buildroot}%{python_sitearch}/zookeeper.so
popd

find %{buildroot} -name '*.la' -exec rm -f {} ';'
find %{buildroot} -name '*.a' -exec rm -f {} ';'

mkdir -p %{buildroot}%{_unitdir}
mkdir -p %{buildroot}%{_sysconfdir}/zookeeper
mkdir -p %{buildroot}%{_localstatedir}/log/zookeeper
mkdir -p %{buildroot}%{_sharedstatedir}/zookeeper
mkdir -p %{buildroot}%{_sharedstatedir}/zookeeper/data
mkdir -p %{buildroot}%{_sharedstatedir}/zookeeper/log
install -p -m 0644 %{SOURCE2} %{buildroot}%{_unitdir}
install -p -m 0640 conf/log4j.properties %{buildroot}%{_sysconfdir}/zookeeper
install -p -m 0640 conf/zoo_sample.cfg %{buildroot}%{_sysconfdir}/zookeeper
touch %{buildroot}%{_sysconfdir}/zookeeper/zoo.cfg
touch %{buildroot}%{_sharedstatedir}/zookeeper/data/myid

%pre
getent group zookeeper >/dev/null || groupadd -r zookeeper
getent passwd zookeeper >/dev/null || \
    useradd -r -g zookeeper -d %{_sharedstatedir}/zookeeper -s /sbin/nologin \
    -c "ZooKeeper service account" zookeeper

%post
%systemd_post zookeeper.service
/sbin/ldconfig

%preun
%systemd_preun zookeeper.service

%postun
%systemd_postun_with_restart zookeeper.service
/sbin/ldconfig

%files
%{_bindir}/cli_mt
%{_bindir}/cli_st
%{_bindir}/load_gen
%{_bindir}/zk*.sh
%{_libexecdir}/zkEnv.sh
%{_libdir}/lib*.so.*

%attr(0755,root,root) %dir %{_sysconfdir}/zookeeper
%attr(0644,root,root) %ghost %config(noreplace) %{_sysconfdir}/zookeeper/zoo.cfg
%attr(0644,root,root) %{_sysconfdir}/zookeeper/zoo_sample.cfg
%attr(0644,root,root) %config(noreplace) %{_sysconfdir}/zookeeper/log4j.properties

%attr(0755,zookeeper,zookeeper) %dir %{_localstatedir}/log/zookeeper
%attr(0755,root,root) %dir %{_sharedstatedir}/zookeeper
%attr(0750,zookeeper,zookeeper) %dir %{_sharedstatedir}/zookeeper/data
%attr(0640,zookeeper,zookeeper) %ghost %{_sharedstatedir}/zookeeper/data/myid
%attr(0755,zookeeper,zookeeper) %dir %{_sharedstatedir}/zookeeper/log
%{_unitdir}/zookeeper.service
%doc CHANGES.txt LICENSE.txt NOTICE.txt README.txt

%files java
%dir %{_javadir}/%{name}
%{_javadir}/%{name}/%{name}.jar
%{_javadir}/%{name}/%{name}-tests.jar
%{_javadir}/%{name}/%{name}-ZooInspector.jar
%if 0%{?fedora} >= 21
%{_datadir}/maven-poms/%{name}-%{name}.pom
%{_datadir}/maven-poms/%{name}-%{name}-ZooInspector.pom
%{_datadir}/maven-metadata/%{name}.xml
%else
%{_mavendepmapfragdir}/%{name}
%{_mavenpomdir}/JPP.%{name}-%{name}.pom
%{_mavenpomdir}/JPP.%{name}-%{name}-ZooInspector.pom
%endif
%doc CHANGES.txt LICENSE.txt NOTICE.txt README.txt

%files devel
%{_includedir}/%{name}/
%{_libdir}/*.so
%doc src/c/LICENSE src/c/NOTICE.txt

%files javadoc
%{_javadocdir}/%{name}
%doc LICENSE.txt NOTICE.txt

%files -n python-%{name}
%{python_sitearch}/ZooKeeper-?.?-py%{python_version}.egg-info
%{python_sitearch}/zookeeper.so
%doc LICENSE.txt NOTICE.txt src/contrib/zkpython/README

%changelog
* Fri Oct 16 2015 Christopher Tubbs <ctubbsii-fedora@apache.org> - 3.4.6-10
- Rollback changes for netty 3.9.3 for f21 only

* Fri Oct 16 2015 Christopher Tubbs <ctubbsii-fedora@apache.org> - 3.4.6-9
- Update zkEnv.sh CLASSPATH to fix bz#1261458

* Thu Aug 27 2015 Jonathan Wakely <jwakely@redhat.com> - 3.4.6-8
- Rebuilt for Boost 1.59

* Wed Jul 29 2015 Fedora Release Engineering <rel-eng@lists.fedoraproject.org> - 3.4.6-7
- Rebuilt for https://fedoraproject.org/wiki/Changes/F23Boost159

* Wed Jul 22 2015 David Tardon <dtardon@redhat.com> - 3.4.6-6
- rebuild for Boost 1.58

* Fri Jun 19 2015 Fedora Release Engineering <rel-eng@lists.fedoraproject.org> - 3.4.6-5
- Rebuilt for https://fedoraproject.org/wiki/Fedora_23_Mass_Rebuild

* Sun Feb 15 2015 Peter Robinson <pbrobinson@fedoraproject.org> 3.4.6-4
- Update netty3 patch for 3.9.3

* Tue Jan 27 2015 Petr Machata <pmachata@redhat.com> - 3.4.6-3
- Rebuild for boost 1.57.0

* Thu Oct 23 2014 Timothy St. Clair <tstclair@redhat.com> - 3.4.6-2
- Add back -java subpackage

* Tue Oct 21 2014 Timothy St. Clair <tstclair@redhat.com> - 3.4.6-1
- Update to latest stable series
- Cleanup and overhaul package
- Updated system integration

* Mon Aug 18 2014 Fedora Release Engineering <rel-eng@lists.fedoraproject.org> - 3.4.5-20
- Rebuilt for https://fedoraproject.org/wiki/Fedora_21_22_Mass_Rebuild

* Sat Jun 07 2014 Fedora Release Engineering <rel-eng@lists.fedoraproject.org> - 3.4.5-19
- Rebuilt for https://fedoraproject.org/wiki/Fedora_21_Mass_Rebuild

* Fri May 23 2014 Petr Machata <pmachata@redhat.com> - 3.4.5-18
- Rebuild for boost 1.55.0

* Mon Feb 24 2014 Timothy St. Clair <tstclair@redhat.com> - 3.4.5-17
- Update due to cascading dependencies around java-headless

* Fri Jan 31 2014 Timothy St. Clair <tstclair@redhat.com> - 3.4.5-16
- Update of tests.jar due to netty3 compat packaging conflicts

* Fri Jan 24 2014 Timothy St. Clair <tstclair@redhat.com> - 3.4.5-15
- Update jline and netty3 for f21 builds

* Fri Oct 25 2013 Timothy St. Clair <tstclair@redhat.com> - 3.4.5-14
- Update dependencies to jline1

* Wed Sep 18 2013 Timothy St. Clair <tstclair@redhat.com> - 3.4.5-13
- Fixed the atomic patch which actually caused recursive crashing on zookeeper_close

* Tue Jul 30 2013 Petr Machata <pmachata@redhat.com> - 3.4.5-12
- Rebuild for boost 1.54.0

* Tue Jul 30 2013 gil cattaneo <puntogil@libero.it> 3.4.5-11
- fix changelog entries

* Mon Jul 22 2013 Timothy St. Clair <tstclair@redhat.com> - 3.4.5-10
- update permissions to be in line with default policies

* Mon Jul 22 2013 gil cattaneo <puntogil@libero.it> 3.4.5-9
- removed not needed %%defattr (only required for rpm < 4.4)
- removed not needed Group fields (new package guideline)
- fix directory ownership in java sub package

* Mon Jul 22 2013 Timothy St. Clair <tstclair@redhat.com> - 3.4.5-8
- cleanup file ownership properties.

* Sat Jun 15 2013 Jeffrey C. Ollie <jeff@ocjtech.us> - 3.4.5-7
- add server subpackage

* Fri Jun 14 2013 Dan Horák <dan[at]danny.cz> - 3.4.5-6
- use fetch_and_add from GCC, fixes build on non-x86 arches

* Tue Jun 11 2013  gil cattaneo <puntogil@libero.it> 3.4.5-5
- fixed zookeeper.so non-standard-executable-perm thanks to Björn Esser

* Tue Jun 11 2013  gil cattaneo <puntogil@libero.it> 3.4.5-4
- enabled hardened-builds
- fixed fully versioned dependency in subpackages (lib-devel and python)
- fixed License tag
- moved large documentation in lib-doc subpackage

* Sat Apr 27 2013 gil cattaneo <puntogil@libero.it> 3.4.5-3
- built ZooInspector
- added additional poms files

* Tue Apr 23 2013 gil cattaneo <puntogil@libero.it> 3.4.5-2
- building/packaging of the zookeeper-test.jar thanks to Robert Rati

* Sun Dec 02 2012 gil cattaneo <puntogil@libero.it> 3.4.5-1
- update to 3.4.5

* Tue Oct 30 2012 gil cattaneo <puntogil@libero.it> 3.4.4-3
- fix missing hostname

* Fri Oct 12 2012 gil cattaneo <puntogil@libero.it> 3.4.4-2
- add ant-junit as BR

* Fri Oct 12 2012 gil cattaneo <puntogil@libero.it> 3.4.4-1
- update to 3.4.4

* Fri May 18 2012 gil cattaneo <puntogil@libero.it> 3.4.3-1
- initial rpm
