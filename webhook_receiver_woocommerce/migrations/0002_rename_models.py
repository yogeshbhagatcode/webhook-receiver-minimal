# Generated by Django 2.2.18 on 2021-02-09 08:36

from django.db import migrations


class Migration(migrations.Migration):

    # SQLite < 3.23 (i.e. anything before Ubuntu Focal) can't handle
    # atomic table renames. Once only Ubuntu Focal is meant to be supported,
    # we can drop this.
    atomic = False

    dependencies = [
        ('webhook_receiver_woocommerce', '0001_initial'),
    ]

    operations = [
        migrations.RenameModel(
            old_name='Order',
            new_name='WooCommerceOrder',
        ),
        migrations.RenameModel(
            old_name='OrderItem',
            new_name='WooCommerceOrderItem',
        ),
    ]
